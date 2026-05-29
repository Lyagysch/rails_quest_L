class Quest2StudentService
  class << self
    # @return [String]
    def all_agents
      Agent.pluck(:codename).join("\n")
    end

    # @return [String]
    def all_missions
      Mission.order(:title).pluck(:title).join("\n")
    end

    # @return [String]
    def agents_with_missions
      Agent.order(:codename)
           .includes(:missions)
           .map do |agent|
        missions = agent.missions.order(:title).pluck(:title)
        "#{agent.codename}: #{missions.join(', ')}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_missions_sorted_by_mission_count
      # Один запрос: считаем миссии для каждого агента и сортируем
      Agent.left_joins(:missions)
           .group(:id, :codename)
           .select('agents.*, COUNT(missions.id) as missions_count')
           .order('missions_count DESC, agents.codename ASC')
           .map do |agent|
        missions = agent.missions.order(:title).pluck(:title)
        "#{agent.codename} (#{agent.missions_count}): #{missions.join(', ')}"
      end.join("\n")
    end

    # @return [String]
    def agents_with_skills
      Agent.order(:codename)
           .includes(:skills)
           .map do |agent|
        skills = agent.skills.order(:name).pluck(:name)
        "#{agent.codename}: #{skills.join(', ')}"
      end.join("\n")
    end

    # @return [String]
    def skills_by_agent_count
      # Один запрос: считаем агентов для каждого навыка
      Skill.left_joins(:agents)
           .group(:id, :name)
           .select('skills.*, COUNT(agents.id) as agents_count')
           .order('agents_count DESC, skills.name ASC')
           .map do |skill|
        agents = skill.agents.order(:codename).pluck(:codename)
        "#{skill.name} (#{skill.agents_count}): #{agents.join(', ')}"
      end.join("\n")
    end
  end
end