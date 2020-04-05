#!/usr/bin/env ruby

# iTerm2 preferences:
# Profiles > Advanced > "Semantic History"
# Choose "Always run command..."
# Enter: ~/code/github/Fresho-Org/fresho/bin/iterm_command_click "\1" "\2" "\3" "\4" "\5"

filename, linenumber, _textbefore, _textafter, workingdir = *ARGV

IDE_LIFESTYLE = 'emacs'.freeze
DEBUG = true

# debug logging
module Debug
  HOME = File.expand_path('~').freeze
  DEBUG_PATH = "#{HOME}/launches.log".freeze

  def self.log(message)
    return unless DEBUG

    File.open(DEBUG_PATH, 'a') do |file|
      file.puts message
    end
  end
end

# editor launching
module Launcher
  def self.open(path, number)
    log_launch(path, number)
    case IDE_LIFESTYLE
    when 'atom'
      open_default('/usr/local/bin/atom', path, number)
    when 'code'
      open_default('/usr/local/bin/code', path, number)
    when 'emacs'
      open_emacs(path, number)
    when 'mate'
      open_default('/usr/local/bin/mate', path, number)
    when 'mine'
      open_rubymine(path, number)
    when 'subl'
      open_default('/usr/local/bin/subl', path, number)
    when 'xi'
      open_default('/usr/local/bin/xi', path, number)
    end
  end

  def self.log_launch(path, number)
    if number.empty?
      Debug.log("Launching #{path}")
    else
      Debug.log("Launching #{path} on line #{number}")
    end
  end

  def self.open_default(bin, path, number)
    if number.empty?
      system "'#{bin}' #{path}"
    else
      system "'#{bin}' #{path}:#{number}"
    end
  end

  def self.open_emacs(path, number)
    if number.empty?
      system "/usr/local/bin/emacsclient -n #{path}"
    else
      system "/usr/local/bin/emacsclient -n +#{number} #{path}"
    end
  end

  def self.open_rubymine
    if number.empty?
      system "/usr/local/bin/mine #{path}"
    else
      system "/usr/local/bin/mine --line #{number} #{path}"
    end
  end
end

Debug.log("filename=#{filename}")
Debug.log("linenumber=#{linenumber}")
Debug.log("workingdir=#{workingdir}")

filename_sections = filename.split(':')

if filename_sections.length > 1
  filename = filename_sections[0]
  linenumber = filename_sections[1]
end

launchpath = filename.start_with?('/') ? filename : "#{workingdir}/#{filename}"

Launcher.open(launchpath, linenumber)

Debug.log('--------------------')
