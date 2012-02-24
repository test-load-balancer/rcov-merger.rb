require 'rubygems'
require 'rcov'
require 'rcov/formatters'
require 'zlib'
require 'pp'

class MyFormatter < Rcov::BaseFormatter

  def initialize(opts = {})
    super(opts)
    @aggregated_coverage = { }
  end

  def execute
    each_file_pair_sorted do |filename, fileinfo|
      if (@files[filename])
        @files[filename].merge(fileinfo.lines, fileinfo.coverage, fileinfo.counts)
      else
        @files.merge!(filename => fileinfo)
      end
    end
  end

  def dump
    @aggregated_coverage.each do |filename, fileinfo|
      puts "#{filename} : #{fileinfo.coverage}, #{fileinfo.counts}"
    end
  end
end

formatter = MyFormatter.new

Zlib::GzipReader.open("/tmp/reports/out_1"){|gz| Marshal.load(gz)}[:coverage].dump_coverage_info([formatter])
Zlib::GzipReader.open("/tmp/reports/out_2"){|gz| Marshal.load(gz)}[:coverage].dump_coverage_info([formatter])

puts "%.1f%%   %d Lines   %d LOC" % [formatter.code_coverage * 100, formatter.num_lines, formatter.num_code_lines]


