module SystemUnderTest
  def init
    @stack ||= HashWithIndifferentAccess.new
  end

  def sut
    return self
  end

  #add to stack
  def add name, value
    init

    if @stack[name].nil?
      #we need to push onto the stack and if necessary create our stack
      @stack[name] = (!@stack[name].kind_of?(Array) ? [@stack[name]] : @stack[name]) << value
    else
      @stack[name] = value
    end
  end

  #get top of stack
  def get name
    init

    raise "Property '#{name}' not defined" if @stack[name].nil?

    if @stack[name].kind_of?(Array)
      @stack[name].last
    else
      @stack[name]
    end
  end

  #does item on stack exist?
  def does_not_exist name
    init

    @stack[name].nil? == true
  end

  # get top of stack and remove
  def pop name
    init

    raise "Property '#{name}' not defined" if @stack[name].nil?

    if @stack[name].kind_of?(Array)
      @stack[name].pop
    else
      @stack[name]
    end
  end
end