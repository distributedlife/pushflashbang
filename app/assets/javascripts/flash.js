function flash_message(type, message)
{
  $j("#flash").append("<div class='alert-message " + type + "'><p>" + message + "</p></div>");
}