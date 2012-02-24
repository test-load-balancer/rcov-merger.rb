require 'rubygems'
require 'rcov/formatters'

module Tlb
  class MergeFormatter < Rcov::BaseFormatter
    def execute
      each_file_pair_sorted do |filename, fileinfo|
        if (@files[filename])
          @files[filename].merge(fileinfo.lines, fileinfo.coverage, fileinfo.counts)
        else
          @files.merge!(filename => fileinfo)
        end
      end
    end

    def format(configured_formatter)
      each_file_pair_sorted do |filename, fileinfo|
        configured_formatter.add_file(filename, fileinfo.lines, fileinfo.coverage, fileinfo.counts)
      end
      configured_formatter.execute
    end
  end
end
