Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  # ======== LOBBY ========
  root "quests#index"
  patch "locale/:locale", to: "locales#update", as: :locale

  # Quest briefing pages (teacher's code — don't modify)
  scope :quests do
    get ":number", to: "quests#show",   as: :quest,        constraints: { number: /[1-5]/ }
  end

  # ======== QUEST 1: ========
  # Первый квест посвящён моделям, миграциям, связям и валидациям.
  # Здесь ничего добавлять не нужно — вся работа будет в app/models и db/migrate.

  # ======== QUEST 2: ========
  # Тут тоже ничего не нужно добавлять, вся работа будет в app/models и app/helpers.

  # ======== QUEST 3: ========
  # Добавь сюда маршруты для Quest3AccessGateController.

  get "/access_gate/ping", to: "quest3_access_gate#ping"
  post "/access_gate/scan", to: "quest3_access_gate#scan"
  patch "/access_gate/power", to: "quest3_access_gate#power"
  delete "/access_gate/logs/stale", to: "quest3_access_gate#stale_logs"
  get "/access_gate/clearance", to: "quest3_access_gate#clearance"
  post "/access_gate/verify", to: "quest3_access_gate#verify"
  get "/access_gate/granted", to: "quest3_access_gate#granted", as: :granted
  get "/access_gate/denied", to: "quest3_access_gate#denied", as: :denied
end
