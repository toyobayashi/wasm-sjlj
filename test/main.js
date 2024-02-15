const { WASI } = require('wasi')
const path = require('path')
const fs = require('fs')

const buffer = fs.readFileSync(path.join(__dirname, './main.wasm'))
const wasi = new WASI({ version: 'preview1' })

WebAssembly.instantiate(buffer, {
  wasi_snapshot_preview1: wasi.wasiImport
}).then(({ instance }) => {
  const exitCode = wasi.start(instance)
  process.exitCode = exitCode
  if (exitCode !== 0) {
    console.error(`\nExit code: ${exitCode}, test failed\n`)
  }
})
