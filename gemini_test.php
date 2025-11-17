<?php
require_once 'config/config.php';
require_once 'core/Database.php';

$db = Database::getInstance()->getConnection();
$stmt = $db->prepare("SELECT * FROM chatbot_settings WHERE id = 1");
$stmt->execute();
$settings = $stmt->fetch(PDO::FETCH_ASSOC);

if (empty($settings['api_key'])) {
    die("API key is not set in the database.");
}

$model = $settings['model'] ?? 'gemini-2.5-flash';
$apiKey = $settings['api_key'];
$apiUrl = 'https://generativelanguage.googleapis.com/v1/models/' . $model . ':generateContent?key=' . $apiKey;

$data = [
    'contents' => [
        [
            'parts' => [
                [
                    'text' => 'Hello'
                ]
            ]
        ]
    ]
];

$options = [
    'http' => [
        'header'  => "Content-Type: application/json\r\n",
        'method'  => 'POST',
        'content' => json_encode($data),
        'ignore_errors' => true
    ],
];

$context  = stream_context_create($options);
$result = file_get_contents($apiUrl, false, $context);

echo "Response from Gemini API:\n";
print_r($result);
