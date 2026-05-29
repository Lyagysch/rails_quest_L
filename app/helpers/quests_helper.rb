module QuestsHelper
  def quest_briefing_template(number)
    "quests/briefings/#{I18n.locale}/quest_#{number}"
  end

  def current_quest_step_progress(quest_number, quest_two_tasks, quest_three_tasks)
    tasks = case quest_number
    when 2 then quest_two_tasks
    when 3 then quest_three_tasks
    else nil
    end

    return nil if tasks.blank?

    solved_steps = tasks.count { |task| task[:solved] }
    total_steps = tasks.size

    {
      solved_steps: solved_steps,
      total_steps: total_steps,
      label: if I18n.locale == :ru
               "#{solved_steps}/#{total_steps} шагов совпало"
             else
               "#{solved_steps}/#{total_steps} steps matched"
             end,
      success: solved_steps == total_steps && total_steps.positive?
    }
  end

  def truncated_probe_output(output, max_length: 1000)
    text = output.to_s
    return text if text.length <= max_length

    "#{text.first(max_length)}…"
  end

  def quest_two_step_path(step)
    quest_path(2, step: step)
  end

  def quest_three_step_path(step)
    quest_path(3, step: step)
  end
end
