#StatsD Configuration
StatsD.server = '23.21.142.181:8125'
StatsD.mode = :production


def get_metric_prefix
  "#{ENV['COMPANY']}.#{ENV['PRODUCT']}.#{ENV['ENV']}.#{ENV['RELEASE']}.metrics"
end

namespace :heroku do
  def get_release_number environment
    command = "heroku releases --app #{environment} | grep \"^v[0-9]*\" -m 1 -oh"

    ENV['RELEASE'] = `#{command}`.strip!
  end

  task :setup do
    raise_if_not_set "HEROKU_ENV"
  end

  task :export_release_number => [:setup] do
    get_release_number ENV['HEROKU_ENV']
  end
end

namespace :report do
  def raise_if_not_set key
    raise "Can't report release because '#{key}' environment variable is not set" if ENV["#{key}"].blank?
  end

  namespace :heroku do
    namespace :export_config do
      desc "set env variables for heroku for metric gathering in PRODUCTION"
      task :production => [:setup_common, :setup_prod] do
        Rake::Task["report:release:all_set"].invoke
        Rake::Task["heroku:setup"].invoke
        Rake::Task["heroku:export_release_number"].invoke

        `heroku config:add COMPANY=#{ENV['COMPANY']} PRODUCT=#{ENV['PRODUCT']} ENV=#{ENV['ENV']} RELEASE=#{ENV['RELEASE']} --app #{ENV['HEROKU_ENV']}`
      end

      desc "set env variables for heroku for metric gathering in STAGING"
      task :staging => [:setup_common, :setup_staging] do
        Rake::Task["report:release:all_set"].invoke
        Rake::Task["heroku:setup"].invoke
        Rake::Task["heroku:export_release_number"].invoke

        `heroku config:add COMPANY=#{ENV['COMPANY']} PRODUCT=#{ENV['PRODUCT']} ENV=#{ENV['ENV']} RELEASE=#{ENV['RELEASE']} --app #{ENV['HEROKU_ENV']}`
      end
    end
  end


  task :setup_common do
    ENV['COMPANY'] = "pushflashbang"
    ENV['PRODUCT'] = "momentum"
  end

  task :setup_prod do
    ENV['ENV'] = "production"

    unless ENV['HEROKU_ENV'].blank?
      Rake::Task["heroku:export_release_number"].invoke
    end
  end

  task :setup_staging do
    ENV['ENV'] = "staging"

    unless ENV['HEROKU_ENV'].blank?
      Rake::Task["heroku:export_release_number"].invoke
    end
  end



  namespace :release do
    task :all_set do
      raise_if_not_set "COMPANY"
      raise_if_not_set "PRODUCT"
      raise_if_not_set "ENV"
      raise_if_not_set "RELEASE"
    end

    desc "verify config for report to statsd server of release to PRODUCTION"
    task :production_verify => [:setup_common, :setup_prod, :all_set] do
      ap "#{get_metric_prefix}.releases"
    end

    desc "verify config for report to statsd server of release to STAGING"
    task :staging_verify => [:setup_common, :setup_staging, :all_set] do
      ap "#{get_metric_prefix}.releases"
    end

    desc "report to statsd server of release to PRODUCTION"
    task :production => [:setup_common, :setup_prod, :all_set] do
      StatsD.increment("#{get_metric_prefix}.releases")
    end

    desc "report to statsd server of release to STAGING"
    task :staging => [:setup_common, :setup_staging, :all_set] do
      StatsD.increment("#{get_metric_prefix}.releases")
    end
  end

  namespace :ci do
    task :all_set do
      Rake::Task["report:release:all_set"].invoke
    end

    task :setup_ci do
      ENV['ENV'] = "ci"
    end

    namespace :jenkins do
      task :setup_spec => [:setup_ci] do
        ENV['RELEASE'] = 'spec'
      end

      task :setup_cucumber => [:setup_ci] do
        ENV['RELEASE'] = 'cucumber'
      end

      task :spec => [:setup_common, :setup_spec, :all_set] do
        StatsD.measure("#{get_metric_prefix}.duration") do
          Rake::Task["spec"].invoke
        end
      end

      task :cucumber => [:setup_common, :setup_cucumber, :all_set] do
        StatsD.measure("#{get_metric_prefix}.duration") do
          Rake::Task["cucumber"].invoke
        end
      end
    end
  end
end