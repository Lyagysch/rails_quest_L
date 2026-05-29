require_relative "quest_helper"

class Quest3AccessGateRoutingTest < QuestTestCase
  TEST_SCOPE = %i[tests quest_3].freeze

  setup do
    upsert_quest_status(1, "accepted")
    upsert_quest_status(2, "locked")
    upsert_quest_status(3, "unlocked")
  end

  test I18n.t(:service_matches_reference, scope: TEST_SCOPE) do
    Quest3DataService.tasks.each do |task|
      assert_equal normalized_output(task[:expected_output]),
        normalized_output(Quest3DataService.output_for(task[:key])),
        I18n.t(:step_mismatch, scope: TEST_SCOPE, step: task[:step])
    end
  end

  test I18n.t(:briefing_contains_hints, scope: TEST_SCOPE) do
    get quest_path(3)

    assert_response :success
    assert_includes response.body, "config/routes.rb"
    assert_includes response.body, "app/controllers/quest3_access_gate_controller.rb"
    assert_includes response.body, "/access_gate/ping"
    assert_includes response.body, "Quest3DataService.output_for(:ping_status)"
  end

  private

  def normalized_output(output)
    output.to_s.lines.map(&:rstrip).join("\n").strip
  end

  def upsert_quest_status(number, status)
    quest = QuestProgress.find_or_initialize_by(quest_number: number)
    quest.status = status
    quest.unlocked_at = Time.current if status == "unlocked"
    quest.accepted_at = Time.current if status == "accepted"
    quest.save!
  end
end
