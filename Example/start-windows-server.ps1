$ApiKey = "EAANPpCZAFd5EBO1B42kIx1boxZCzDY58QZB3wgshhjNNXq4plaFhqQRxUWoPEqZAE2RJWd6CZCbjxbJMAdJRF1ZAX6GHq19YHUHyeRvzvhXjkr7GzsHhFrECrVYnLlScnIa4262OcCyrS0ZA0qzwuDU5h5UqSd2DXc27MkP8BiBakNyr9jhtlL5qAfmfeMB2ULWAQZDZD"  # API key para proteger las llamadas HTTP

# Este script asume que ya se ejecutó install-windows-server.ps1 para instalar dependencias
$env:API_KEY = $ApiKey
npx tsx .\Example\windows-server.ts
