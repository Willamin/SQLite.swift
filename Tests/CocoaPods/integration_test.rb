#!/usr/bin/env ruby

require 'cocoapods'
require 'cocoapods/validator'
require 'minitest/autorun'

class IntegrationTest < Minitest::Test

  def test_validate_project
    assert validator.validate, "validation failed: #{validator.failure_reason}"
  end

  private

  def validator
    @validator ||= Pod::Validator.new(podspec, ['https://github.com/CocoaPods/Specs.git']).tap do |validator|
        validator.config.verbose = true
        validator.no_clean = true
        validator.use_frameworks = true
        validator.fail_fast = true
        validator.local = true
        validator.allow_warnings = true
        subspec = ENV['VALIDATOR_SUBSPEC']
        if subspec == 'none'
          validator.no_subspecs = true
        else
          validator.only_subspec = subspec
        end
    end
  end

  def podspec
    File.expand_path(File.dirname(__FILE__) + '/../../SQLite.swift.podspec')
  end
end
