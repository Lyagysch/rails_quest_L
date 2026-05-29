class Quest3DataService
  # Don't edit this file. It stores the routing checkpoints and probes the app the same way the UI does.

  TASKS = [
    {
      step: 1,
      key: :ping_status,
      title: {
        ru: "GET-маршрут: пинг шлюза",
        en: "GET route: gate ping"
      },
      description: {
        ru: "Добавь GET-маршрут /access_gate/ping и action ping, который возвращает простой текстовый ответ.",
        en: "Add a GET route for /access_gate/ping and a ping action that returns a plain text response."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:ping_status)"',
      expected_output: "200 OK | ACCESSGATE PING OK",
      request: {
        method: :get,
        path: "/access_gate/ping"
      },
      formatter: :body
    },
    {
      step: 2,
      key: :scan_status,
      title: {
        ru: "POST-форма: сканирование сектора",
        en: "POST form: sector scan"
      },
      description: {
        ru: "Добавь POST-маршрут /access_gate/scan. Action scan должен взять agent и sector из params и собрать строку ответа.",
        en: "Add a POST route for /access_gate/scan. The scan action should read agent and sector from params and build the response string."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:scan_status)"',
      expected_output: "200 OK | SCAN RESULT: Echo -> sector 7",
      request: {
        method: :post,
        path: "/access_gate/scan",
        params: { agent: "Echo", sector: "7" }
      },
      formatter: :body
    },
    {
      step: 3,
      key: :power_status,
      title: {
        ru: "PATCH-запрос: пересчёт мощности",
        en: "PATCH request: power recalculation"
      },
      description: {
        ru: "Добавь PATCH-маршрут /access_gate/power. Action power должен сложить current и boost.",
        en: "Add a PATCH route for /access_gate/power. The power action should sum current and boost."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:power_status)"',
      expected_output: "200 OK | POWER TOTAL: 24",
      request: {
        method: :patch,
        path: "/access_gate/power",
        params: { current: "18", boost: "6" }
      },
      formatter: :body
    },
    {
      step: 4,
      key: :stale_logs_status,
      title: {
        ru: "DELETE-запрос: очистка старых логов",
        en: "DELETE request: clear stale logs"
      },
      description: {
        ru: "Добавь DELETE-маршрут /access_gate/logs/stale. Action stale_logs должен вернуть количество удалённых логов. КОличество надо взять из запроса, на самом деле ничего удалять не надо.",
        en: "Add a DELETE route for /access_gate/logs/stale. The stale_logs action should return how many logs were cleared. Read the count from the request; nothing actually needs to be deleted."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:stale_logs_status)"',
      expected_output: "200 OK | STALE LOGS CLEARED: 3",
      request: {
        method: :delete,
        path: "/access_gate/logs/stale",
        params: { count: "3" }
      },
      formatter: :body
    },
    {
      step: 5,
      key: :clearance_status,
      title: {
        ru: "before_action + after_action: уровень допуска",
        en: "before_action + after_action: clearance level"
      },
      description: {
        ru: "В action clearance используй before_action, чтобы подготовить сумму level + boost, а после ответа запиши заголовок X-Access-Gate-Trace со значением CLEAREANCE_GRANTED.",
        en: "In the clearance action, use a before_action to prepare the level + boost sum, then set the X-Access-Gate-Trace header to CLEAREANCE_GRANTED in an after_action."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:clearance_status)"',
      expected_output: "200 OK | CLEARANCE TOTAL: 6 | TRACE: CLEAREANCE_GRANTED",
      request: {
        method: :get,
        path: "/access_gate/clearance",
        params: { level: "4", boost: "2" }
      },
      formatter: :body_with_trace
    },
    {
      step: 6,
      key: :verify_success_status,
      title: {
        ru: "Условный redirect: успешная верификация",
        en: "Conditional redirect: successful verification"
      },
      description: {
        ru: "Добавь POST-маршрут /access_gate/verify. Если token начинается с alpha, выполни редирект на /access_gate/granted?token=TOKEN.",
        en: "Add a POST route for /access_gate/verify. If the token starts with alpha, perform a redirect to /access_gate/granted?token=TOKEN."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:verify_success_status)"',
      expected_output: "302 FOUND | REDIRECT: /access_gate/granted?token=alpha-7",
      request: {
        method: :post,
        path: "/access_gate/verify",
        params: { token: "alpha-7" }
      },
      formatter: :redirect
    },
    {
      step: 7,
      key: :granted_status,
      title: {
        ru: "GET-маршрут после redirect: страница доступа",
        en: "GET route after redirect: granted page"
      },
      description: {
        ru: "Добавь GET-маршрут /access_gate/granted. Используй before_action, чтобы достать token из params, и after_action, чтобы выставить X-Access-Gate-Trace = token_checked.",
        en: "Add a GET route for /access_gate/granted. Use a before_action to read the token from params and an after_action to set X-Access-Gate-Trace = token_checked."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:granted_status)"',
      expected_output: "200 OK | TOKEN ACCEPTED: alpha-7 | TRACE: token_checked",
      request: {
        method: :get,
        path: "/access_gate/granted",
        params: { token: "alpha-7" }
      },
      formatter: :body_with_trace
    },
    {
      step: 8,
      key: :verify_failure_status,
      title: {
        ru: "Условный redirect: отклонённый токен",
        en: "Conditional redirect: rejected token"
      },
      description: {
        ru: "В том же action verify добавь ветку для неверного token: редирект на /access_gate/denied?token=TOKEN.",
        en: "In the same verify action, add the branch for an invalid token: redirect to /access_gate/denied?token=TOKEN."
      },
      command: 'bin/rails runner "puts Quest3DataService.output_for(:verify_failure_status)"',
      expected_output: "302 FOUND | REDIRECT: /access_gate/denied?token=omega-9",
      request: {
        method: :post,
        path: "/access_gate/verify",
        params: { token: "omega-9" }
      },
      formatter: :redirect
    }
  ].freeze

  class << self
    def tasks
      TASKS
    end

    def output_for(key)
      task = TASKS.find { |item| item[:key] == key }
      return "" unless task

      safely { perform_probe(task) }
    end

    private

    def safely
      yield.to_s
    rescue StandardError
      ""
    end

    def perform_probe(task)
      session = ActionDispatch::Integration::Session.new(Rails.application)
      request = task.fetch(:request)
      params = request[:params] || {}

      session.public_send(request.fetch(:method), request.fetch(:path), params: params)

      format_response(task.fetch(:formatter), session.response)
    end

    def format_response(formatter, response)
      status_line = [ response.status, Rack::Utils::HTTP_STATUS_CODES.fetch(response.status, "UNKNOWN").upcase ].join(" ")

      case formatter
      when :body
        [ status_line, response.body.to_s.strip ].join(" | ")
      when :body_with_trace
        trace = response.headers["X-Access-Gate-Trace"].to_s
        [ status_line, response.body.to_s.strip, "TRACE: #{trace}" ].join(" | ")
      when :redirect
        location = normalize_location(response.headers["Location"])
        [ status_line, "REDIRECT: #{location}" ].join(" | ")
      else
        ""
      end
    end

    def normalize_location(location)
      return "" if location.blank?

      uri = URI.parse(location)
      uri.host ? uri.request_uri : location
    rescue URI::InvalidURIError
      location.to_s
    end
  end
end
