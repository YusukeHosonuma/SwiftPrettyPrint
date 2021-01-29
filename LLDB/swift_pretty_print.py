import lldb
import os
import shlex
import optparse

def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand("command regex _p  's/(.+)/e -l swift -o -- var option = Pretty.sharedOption; option.prefix = nil; Pretty.print(%1, option: option)/'")
    debugger.HandleCommand("command regex _pp 's/(.+)/e -l swift -o -- var option = Pretty.sharedOption; option.prefix = nil; Pretty.prettyPrint(%1, option: option)/'")
    # debugger.HandleCommand('command script add -f swift_pretty_print.handle_command swift_pretty_print -h "Short documentation here"')

def handle_command(debugger, command, exe_ctx, result, internal_dict):
    command_args = shlex.split(command, posix=False)
    parser = generate_option_parser()
    try:
        (options, args) = parser.parse_args(command_args)
    except:
        result.SetError(parser.usage)
        return

    # Uncomment if you are expecting at least one argument
    # clean_command = shlex.split(args[0])[0]

    result.AppendMessage('Hello! the swift_pretty_print command is working!')

def generate_option_parser():
    usage = "usage: %prog [options] TODO Description Here :]"
    parser = optparse.OptionParser(usage=usage, prog="swift_pretty_print")
    return parser