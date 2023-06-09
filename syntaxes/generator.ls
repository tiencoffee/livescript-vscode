objKeys = <[
   window
   String
   Number
   Array
   Object
   Symbol
   Math
   Node
   JSON
   Promise
   Intl
   Document.prototype|document
   String.prototype
   Number.prototype
   Array.prototype
   RegExp.prototype
   Node.prototype
   Element.prototype
   Function.prototype
   Promise.prototype
]>

objs = {}
for val in objKeys
   [val, prefix] = val.split \|
   objs[val] =
      props: []
      methods: []
   if prefix?
      objs[val].prefix = prefix

for k, res of objs
   obj = window.eval(k)
   descs = Object.getOwnPropertyDescriptors obj
   willIgnoreName = k is \window or (k.includes \.prototype and not res.prefix)

   for name, desc of descs
      if k is \window and name in <[livescript]>
         continue

      if willIgnoreName and name in <[name]>
         continue

      if (typeof desc.value isnt \function) or (name.0 is name.0.toUpperCase! and name isnt name.toUpperCase!)
         res.props.push name
      else
         res.methods.push name

json = JSON.stringify objs,, "   "

preEl.textContent = json

addEventListener \keydown (event) !->
   if event.code is \KeyS
      [file] = await showOpenFilePicker do
         suggestedName: \generator.json
         excludeAcceptAllOption: yes
         types: [
            description: \JSON
            accept:
               "application/json": [\.json]
         ]
      writable = await file.createWritable!
      await writable.write json
      await writable.close!
