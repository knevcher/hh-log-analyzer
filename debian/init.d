#!/usr/bin/env python
#coding=utf8

import sys, os, time
from daemon import runner

conf_file_path = '/etc/default/hh-log-analyzer'
execfile(conf_file_path)

class LogAnalyzer(object):
    def __init__(self, pidfile_path, parsing_interval):
        self._init_streams()
        self.pidfile_timeout = 10

        self.pidfile_path = pidfile_path
        self.parsing_interval = parsing_interval

        self._parser_runner_path = '/var/lib/hh-log-analyzer/get_statistics.sh'

    def _init_streams(self):

        self._stream_path = '/tmp/hh-log-analyzer'

        if not os.path.exists(self._stream_path):
            stream_file = open(self._stream_path, 'w')
            stream_file.write('')
            stream_file.close()

        self.stdin_path = self._stream_path
        self.stdout_path = self._stream_path
        self.stderr_path = self._stream_path

    def run(self):
        while(True):
            os.system(self._parser_runner_path)
            time.sleep(self.parsing_interval)


if __name__ == '__main__':
    daemon_runner = runner.DaemonRunner(LogAnalyzer(PIDFILE_PATH, PARSING_INTERVAL))
    daemon_runner.do_action()
