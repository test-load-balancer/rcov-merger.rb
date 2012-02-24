require 'rubygems'
require 'rcov'
require 'rcov/code_coverage_analyzer'

module Tlb
  module Rcov
    module CodeCoverageAnalyzerInflection
      def self.included base
        base.class_eval do
          define_method :clean_script_lines do
            SCRIPT_LINES__.clear
          end
        end
      end
    end
  end
end

Rcov::CodeCoverageAnalyzer.class_eval do
  include Tlb::Rcov::CodeCoverageAnalyzerInflection
end
