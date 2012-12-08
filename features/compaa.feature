Feature: Generate Rake Artifacts Tasks

  In order to be able to view screenshot failures and decide whether accept or reject them
  As a Help Centre developer
  I want to be able to compare screenshots

  Scenario: App just runs
    When I get help for "compaa"
    Then the exit status should be 0
    And the banner should be present
    And the banner should document that this app takes options
    And the following options should be documented:
      | --version |
    And the banner should document that this app takes no arguments

  Scenario: Compare screenshots and approve
    Given a sample reference screenshot
    And a sample generated screenshot
    And a sample difference screenshot
    When I run `compaa` interactively
    And I approve the screenshot
    Then the new reference screenshot should be the same as the sample generated screenshot
    And the difference image should have been deleted

  Scenario: Compare screenshots and reject
    Given a sample reference screenshot
    And a sample generated screenshot
    And a sample difference screenshot
    When I run `compaa` interactively
    And I reject the screenshot
    Then the new reference screenshot should be the same as the original reference screenshot
