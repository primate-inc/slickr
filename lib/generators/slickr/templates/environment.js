const { resolve, basename, extname } = require('path')
const { safeLoad } = require('js-yaml')
const { readFileSync } = require('fs')

const filePath = resolve('config', 'slickr.yml')
const config = safeLoad(readFileSync(filePath), 'utf8')[process.env.NODE_ENV]
const { include_webpacks } = config

const fs = require('fs')

environment.toWebpackConfigForRailsEngine = function() {
  const config = environment.toWebpackConfig()

  Object.keys(include_webpacks).forEach(function(key) {
    const val = this[key]
    const enginePath = `${__dirname}/../../node_modules/${key}/`
    const filePath = `${enginePath}${val}`
    const files = fs.readdirSync(filePath)
    files.forEach(function(file){
      const fullPath = `${filePath}/${file}`
      config.entry[`${basename(fullPath, extname(fullPath))}`] = fullPath
    })
  }, include_webpacks)

  config.module.rules.map(function(rule) {
    if (rule.exclude !== undefined && rule.exclude.source !== undefined && rule.exclude.source.includes('node_modules')) {
      rule.exclude = new RegExp(`node_modules\/(?!${Object.keys(include_webpacks).join('|')})\/`)
      return rule
    } else {
      return rule
    }
  })

  return config
}
