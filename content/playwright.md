# Playwright
Fast and reliable end-to-end testing for modern web apps



## Playwright
Outil d'automatisation de navigateur en Node.js par Microsoft

Chromium + Firefox + Webkit



## Playwright = Puppeteer++
> We are the same team that originally built Puppeteer at Google, but has since then moved on. Puppeteer proved that there is a lot of interest in the new generation of ever-green, capable and reliable automation drivers. With Playwright, we'd like to take it one step further and offer the same functionality for **all** the popular rendering engines. We'd like to see Playwright vendor-neutral and shared governed.



## Fonctionnalités

Sélecteurs texte, CSS, XPath

Sélecteurs CSS positionnel

Recorder

Utilisable avec Jest

Image Docker officielle

...



## Demo

```
npx playwright codegen https://cookorico.com
```

```
playwright.$('text="Créer mon profil"')
playwright.$('css=:text("Créer mon profil")')
playwright.$('css=:text("Créer mon profil"):below(:text("Recruteurs"))')
```



## Problèmes courants tests e2e
Flakiness

Ecrire des tests

Maintenir les tests

Performances



## Problèmes courants tests e2e résolus par Playwright
Flakiness -> network conscious, attentes implicites

Ecrire des tests -> recorder, console de debug

Maintenir les tests -> **black-box testing \o/** sélecteur texte et sélecteur positionnel

Performances -> Chrome Dev Tools protocol / navigateur custo



## Avantages, inconvénients

++ Plus de flakiness  
++ Tellement simple avec codegen  
++ Remplaçant en devenir de Puppeteer  
++ Tests black-box

-- Mature, mais pas encore populaire  
-- Moins bonne DX que Cypress

**A passer en Trial dans le technology radar**



## Vos questions ?

https://playwright.dev


