# карта проекта

```text
.
├── shell.qml                              рут Quickshell: определяет WM, загружает сеттер по IPC
├── global/
│   ├── profiles/default/profile.json     тема default, эффекты и ui_scale_percent
│   ├── themes/default/theme.json          скорость анимаций и прозрачность поверхностей
│   └── quick/
│       ├── state.json                     выбранный язык (пока ru)
│       ├── components/
│       │   ├── Background.qml             фон с плавной сменой цвета и прозрачности
│       │   ├── Sidebar.qml                пустая панель с анимацией ширины; пунктов пока нет
│       │   ├── TileCanvas.qml             область содержимого настроек
│       │   ├── Switch.qml                 простой переключатель
│       │   ├── MaterialSwitch.qml         переключатель в стиле Material You
│       │   └── selected.json              записанный выбор фона, пока не подключён к загрузке
│       ├── services/
│       │   ├── Appearance.qml             читает профиль и тему, отдаёт параметры компонентам
│       │   └── Localization.qml           читает словарь модуля; fallback на русский
│       └── modules/settings/
│           ├── Setter.qml                 общая сборка панели, листа и страницы десктопа
│           ├── map.json                   регистрация десктопов и путей к их desktop.json
│           ├── locales/{ru,en}.json       переводы сеттера
│           └── app/
│               ├── app.qml                отдельное окно вокруг Setter.qml
│               └── meowdots-settings.desktop  ярлык для IPC-открытия окна
├── driftwm/
│   ├── config.toml                         рабочий конфиг WM и хоткеи
│   ├── desktop.json                        путь к странице и заготовке адаптера
│   ├── quick/
│   │   ├── driftwm.qml                     список вкладок DriftWM и временное содержимое
│   │   └── adapter.null                    пустая заготовка адаптера конфигурации
│   └── integrations/hyprlock/hyprlock.conf  конфиг блокировки экрана
├── hyprland/hyprland.conf                 пустая заготовка
├── .gitignore                             игнорируется только .tmp/
├── README.md
├── REFERENCE.md                           эта карта
└── LICENSE
```

путь загрузки настроек: `shell.qml` → `app.qml` → `Setter.qml` → `map.json` → `driftwm/desktop.json` → `driftwm/quick/driftwm.qml`. адаптер пока не реализован; `desktop.json` только указывает на его заготовку. `selected.json` тоже пока не управляет выбором компонентов.

`ui_scale_percent` в профиле задаёт масштаб элементов (100 — исходный размер); окно при этом не масштабируется. `Appearance.qml` преобразует проценты в коэффициент, который получают панель, переключатели и страница DriftWM. `Sidebar.qml` сейчас не показывает вкладки и не содержит кнопку: сворачивание доступно только через свойство `collapsed`.

`~/.config/quickshell` указывает на корень репозитория; `~/.config/hypr/hyprlock.conf` — на `driftwm/integrations/hyprlock/hyprlock.conf`. `.tmp/` содержит локальные файлы и не входит в git.
