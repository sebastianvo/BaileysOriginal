import http from 'http'
import P from 'pino'
import makeWASocket, { fetchLatestBaileysVersion, makeCacheableSignalKeyStore, useMultiFileAuthState } from '../src'

const API_KEY = process.env.API_KEY || 'EAANPpCZAFd5EBO1B42kIx1boxZCzDY58QZB3wgshhjNNXq4plaFhqQRxUWoPEqZAE2RJWd6CZCbjxbJMAdJRF1ZAX6GHq19YHUHyeRvzvhXjkr7GzsHhFrECrVYnLlScnIa4262OcCyrS0ZA0qzwuDU5h5UqSd2DXc27MkP8BiBakNyr9jhtlL5qAfmfeMB2ULWAQZDZD'

const logger = P({ level: 'info' })

async function start() {
  const { state, saveCreds } = await useMultiFileAuthState('auth_info_baileys')
  const { version } = await fetchLatestBaileysVersion()
  const sock = makeWASocket({
    version,
    logger,
    printQRInTerminal: true,
    auth: {
      creds: state.creds,
      keys: makeCacheableSignalKeyStore(state.keys, logger)
    }
  })
  sock.ev.on('creds.update', saveCreds)

  const server = http.createServer((req, res) => {
    const apiKey = req.headers['x-api-key']
    if (apiKey !== API_KEY) {
      res.writeHead(401)
      res.end('unauthorized')
      return
    }

    if (req.method === 'POST' && req.url === '/send-message') {
      let body = ''
      req.on('data', chunk => (body += chunk))
      req.on('end', async () => {
        try {
          const { jid, message } = JSON.parse(body)
          await sock.sendMessage(jid, { text: message })
          res.writeHead(200, { 'Content-Type': 'application/json' })
          res.end(JSON.stringify({ status: 'sent' }))
        } catch (err) {
          res.writeHead(500, { 'Content-Type': 'application/json' })
          res.end(JSON.stringify({ error: (err as Error).message }))
        }
      })
    } else {
      res.writeHead(404)
      res.end('not found')
    }
  })

  server.listen(3000, () => {
    console.log('Baileys server running at http://localhost:3000')
  })
}

start().catch(err => {
  console.error('failed to start server', err)
})
