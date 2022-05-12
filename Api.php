<?php
$data = json_decode(file_get_contents('php://input'), true);

if($data == NUll ||
    !key_exists("type", $data) ||
    !key_exists("id", $data)) {
    return http_response_code(400);
}

$type = $data["type"];
$id = intval($data["id"]);

$pdo = new PDO('mysql:host=x;dbname=x', 'x', 'x');

if($id == 0) {
    switch ($type) {
        case "Search":
            $statement = $pdo->prepare("SELECT COUNT(*) FROM Search");
            break;
        case "Price":
            $statement = $pdo->prepare("SELECT COUNT(*) FROM Price");
            break;
        case "Views":
            $statement = $pdo->prepare("SELECT COUNT(*) FROM Views");
            break;
        default:
            return http_response_code(400);
    }
} else {
    switch ($type) {
        case "Search":
            $statement = $pdo->prepare("SELECT * FROM Search WHERE id = :id");
            break;
        case "Price":
            $statement = $pdo->prepare("SELECT * FROM Price WHERE id = :id");
            break;
        case "Views":
            $statement = $pdo->prepare("SELECT * FROM Views WHERE id = :id");
            break;
        default:
            return http_response_code(400);
    }
    $statement->bindParam(":id", $id);
}

try {
    $result = $statement->execute();
} catch (PDOException $exception) {
    echo $exception->getMessage();
    return http_response_code(409);
}

$ans = $statement->fetchAll();

if (count($ans) != 1) {
    return http_response_code(404);
}

$ans = $ans["0"];

for ($i = 0; $i < count($ans); $i++) {
    unset($ans[$i]);
}

echo json_encode($ans);

return;
?>