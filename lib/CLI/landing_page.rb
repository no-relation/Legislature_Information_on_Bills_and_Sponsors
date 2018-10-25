require_relative '../../config/environment.rb'

# * User is prompted for what they want:
def welcome_explainer
    name = " Legislature Information on Bills and Sponsors "
    print ColorizedString["_/\\_"].white.on_blue 
    puts ColorizedString[name.center(name.length)].black.on_white
    print ColorizedString["\\/\\/"].white.on_blue 
    puts ColorizedString["(from Open States API v1)".center(name.length)].white.on_red
end
