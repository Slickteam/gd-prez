# Taiko
Reliable Browser Automation



## Intro
Outil d'automatisation de navigateur en Node.js par Thoughtworks

Chromium + Firefox (beta)

Utilisable via une invite de commande ou comme lib

```
npm install -g taiko
```



## REPL
```
taiko
> openBrowser()
> goto("google.com")
> .help
> .exit
```



## Sélecteurs
```
highlight($(".class > .foo .bar"))
click("text")
click(text("text"))
click(text("blown"), below("mind"))
```



## Input, screenshot, etc...

```
click("Prénom")
write("François")
write("Pignon", into(textBox("Nom")));
screenshot() // eog Screenshot-1598520730989.png
getCookies()
.api
.api openBrowser
```



## Problèmes courants tests e2e
Flakiness

Ecrire des tests

Maintenir les tests

Performances



## Problèmes courants tests e2e résolus par Taiko
Flakiness -> network conscious, implicit wait

Ecrire des tests -> REPL, auto-complete

Maintenir les tests -> **black-box testing \o/**

Performances -> Chrome Dev Tools protocol



## Tests avec Jest

Taiko peut générer du code (Node.js)
```
.code
```

Qu'on peut intégrer dans Jest
```
npm init -y
npm install --save-dev jest taiko
vim test.spec.js
```



## Tests avec Jest

test.spec.js
```
const { openBrowser, goto, closeBrowser, write, press } = require("taiko");

describe("Taiko with Jest", () => {
  beforeAll(async () => {
    await openBrowser({ headless: false });
  });

  it("should demonstrates stuff", async () => {
    await goto("google.com");
    await write("flying foxes");
    await press("Enter");
  });

  afterAll(async () => {
    await closeBrowser();
  });
});
```



## Tests avec Jest

Ajouter des assertions
```
it("should demonstrates assertions", async () => {
  const candidates = await text("candidats").text();
  expect(Number(candidates.match(/(\d+)/)[1])).toBeLessThan(200000);

  await expect(currentURL()).resolves.toBe(expectedURL);
});
```

Nombreuses configurations, runners parallèle, etc...

*Rappel :* Taiko marche avec Gauge, Mocha, Jest et potentiellement n'importe quel test runner Node.js



## CI, Conteneurisation
Pas d'image Docker officielle

Mais une documentation simple et claire

Headless ou pas

Install du navigateur ou pas



## Avantages, inconvénients
++ Plus de flakiness  
++ **Black-box** grâce aux smart selector  
++ Bonne documentation et support

-- Confidentiel  
-- Support navigateurs : Chromium + Firefox (beta)  
-- Pas de recorder



## Les autres frameworks de tests end-to-end à surveiller
Taiko + Gauge

~~Cypress~~

PlayWright

QA Wolf 🐺



## Vos questions ?

https://taiko.dev