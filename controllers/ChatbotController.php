<?php

class ChatbotController {

    public function handleRequest() {
        header('Content-Type: application/json');

        // Get the user's message from the request body
        $data = json_decode(file_get_contents('php://input'), true);
        $message = $data['message'] ?? '';

        if (empty($message)) {
            echo json_encode(['error' => 'Message is empty']);
            return;
        }

        // Save the user's message to the database
        $this->saveMessage('user', $message);

        // Get the chatbot's response
        $response = $this->getBotResponse($message);

        // Save the bot's response to the database
        $this->saveMessage('bot', $response);

        // Send the response back to the front-end
        echo json_encode(['reply' => $response]);
    }

    private function saveMessage($sender, $message) {
        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("INSERT INTO chat_messages (session_id, sender, message) VALUES (?, ?, ?)");
        // For now, we'll use a hardcoded session ID. In a real application, you'd want to use a unique session ID for each user.
        $stmt->execute([session_id(), $sender, $message]);
    }

    private function getBotResponse($message) {
        $db = Database::getInstance()->getConnection();
        $stmt = $db->prepare("SELECT * FROM chatbot_settings WHERE id = 1");
        $stmt->execute();
        $settings = $stmt->fetch(PDO::FETCH_ASSOC);

        if (empty($settings['api_key'])) {
            return "Chatbot is not configured.";
        }

        $model = $settings['model'] ?? 'gemini-2.5-flash';
        $apiUrl = 'https://generativelanguage.googleapis.com/v1/models/' . $model . ':generateContent?key=' . $settings['api_key'];
        $apiKey = $settings['api_key'];

        $data = [
            'contents' => [
                [
                    'parts' => [
                        [
                            'text' => $message
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
            ],
        ];

        $context  = stream_context_create($options);
        $result = file_get_contents($apiUrl, false, $context);

        if ($result === FALSE) {
            return "Error communicating with the AI model.";
        }

        $response = json_decode($result, true);
        return $response['candidates'][0]['content']['parts'][0]['text'] ?? 'No response from AI.';
    }
}
