'use strict'
Object.defineProperty(exports, '__esModule', { value: true })

const path = require('path')

const include = path.join(__dirname, 'include')
const includeDir = path.relative(process.cwd(), include)
const sources = [
  path.join(__dirname, './src/emscripten_setjmp.c'),
  path.join(__dirname, './src/emscripten_tempret.s'),
]
const targets = path.relative(process.cwd(), path.join(__dirname, 'setjmp.gyp'))

exports.include = include
exports.include_dir = includeDir
exports.sources = sources
exports.targets = targets
