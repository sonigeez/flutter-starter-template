// ignore_for_file: depend_on_referenced_packages, cascade_invocations

import 'package:args/args.dart';
import 'package:flutter_asset_generator/builder.dart';
import 'package:flutter_asset_generator/config.dart';
import 'package:flutter_asset_generator/logger.dart';

void main(List<String> args) {
  final parser = ArgParser();
  parser.addFlag(
    'watch',
    abbr: 'w',
    defaultsTo: null,
    help: 'Continue to monitor changes after execution of orders.',
  );
  final defaultPath = Config.defaultPath;
  parser.addOption(
    'output',
    abbr: 'o',
    help: 'Your resource file path. \n'
        "If it's a relative path, the relative flutter root directory.\n"
        "If you don't specify it, the default path is $defaultPath.\n",
  );
  parser.addOption(
    'src',
    abbr: 's',
    defaultsTo: '.',
    help: 'Flutter project root path',
  );
  parser.addOption(
    'name',
    abbr: 'n',
    help: 'The class name for the constant.\n'
        "If you don't specify it, the default name is R.",
  );
  parser.addFlag(
    'help',
    abbr: 'h',
    help: 'Help usage',
    negatable: false,
  );

  parser.addFlag(
    'debug',
    abbr: 'd',
    help: 'debug info',
    negatable: false,
  );

  parser.addFlag(
    'preview',
    abbr: 'p',
    help: 'Enable preview comments, defaults to true, '
        'use --no-preview to disable this functionality',
    defaultsTo: null,
  );

  final results = parser.parse(args);

  Logger().isDebug = results['debug'] as bool;

  if (results.wasParsed('help')) {
    return;
  }

  final config = Config.fromArgResults(results);

  logger.debug('The config is: $config');

  final builder = ResourceDartBuilder(
    config,
  );
  builder.generateResourceDartFile();
}
