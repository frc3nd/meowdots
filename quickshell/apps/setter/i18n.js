.pragma library

const translations = {
    ru: {
        windowTitle: "настройки meowdots",
        main: "главная",
        console: "консоль",
        setter: "сеттер",
        mainHint: "настройки окружения и темы появятся здесь",
        logsTitle: "логи quickshell",
        logsWaiting: "ожидание логов…",
        appearanceTitle: "интерфейс сеттера",
        animationsTitle: "анимации",
        animationsAll: "все анимации",
        animationsTabs: "переходы между вкладками",
        animationsSwitches: "переключатели",
        animationsContent: "появление содержимого"
    }
}

function text(language, key) {
    const dictionary = translations[language] || translations.ru
    return dictionary[key] || translations.ru[key] || key
}
