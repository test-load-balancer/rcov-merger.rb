require 'rubygems'
require 'rcov'
require 'rcov/formatters'
require 'merge_formatter'
require File.join(File.dirname(__FILE__), 'rcov', 'code_coverage_analyzer_inflection')
require 'zlib'

module Tlb
  class RcovMerger

    attr_accessor :source_dir_path, :formatter_type

    def initialize(source_dir_path, formatter_type)
      @source_dir_path = source_dir_path
      @formatter_type = formatter_type
    end

    def merge_and_generate
      formatter = Tlb::MergeFormatter.new
      merge_reports(formatter)
      formatter.format(configured_formatter.new)
    end

    private

    def merge_reports formatter
      Dir.foreach(source_dir_path) do |file|
        file_name = source_dir_path + "/" + file
        next unless File.file?(file_name)
        # analyzer is an object of type Rcov::CodeCoverageAnalyzer
        analyzer = Zlib::GzipReader.open(file_name) {|gz| Marshal.load(gz)}[:coverage]
        analyzer.dump_coverage_info([formatter])
        analyzer.clean_script_lines
      end
    end

    def configured_formatter
      ::Rcov::TextSummary
    end
  end
end

Tlb::RcovMerger.new('/tmp/reports', nil).merge_and_generate
