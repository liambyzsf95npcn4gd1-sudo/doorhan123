<?php
// Простой класс маршрутизации с поддержкой параметров

class Router {
    private $routes = [];

    public function add($route, $controller, $method) {
        // Преобразуем маршрут в регулярное выражение
        $route = preg_replace('/\{([a-z]+)\}/', '(?P<$1>[^/]+)', $route);
        $route = '#^' . $route . '$#';
        $this->routes[$route] = ['controller' => $controller, 'method' => $method];
    }

    public function dispatch($uri) {
        foreach ($this->routes as $route => $params) {
            if (preg_match($route, $uri, $matches)) {
                $controller = $params['controller'];
                $method = $params['method'];

                // Извлекаем параметры из URI
                $args = array_filter($matches, 'is_string', ARRAY_FILTER_USE_KEY);

                $controller = new $controller();

                // Pass both args and the raw URI to the method
                $controller->$method($args, $uri);
                return;
            }
        }

        // Простая обработка 404
        header("HTTP/1.0 404 Not Found");
        echo "Page not found";
        exit;
    }
}
