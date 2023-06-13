const fs = require('fs')


if(process.argv.length>2){
  const version = process.argv[2]
  const url = `https://github.com/eugenehp/openmp-mobile/releases/download/v${version}/openmp.xcframework.zip`
  const path = `./carthage/openmp-static-xcframework.json`
  
  let json = JSON.parse(fs.readFileSync(path))
  json[version] = url
  fs.writeFileSync(path, JSON.stringify(json, null, 2), 'utf8')
}