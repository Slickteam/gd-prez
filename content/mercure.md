# ![Logo Mercure](https://mercure.rocks/static/logo.svg)

## Real-time API



## Infos générales

* Développé par les-tilleuls.coop
    * Scop fondée par Kévin Dunglas
    * Beaucoup de contributions OpenSource, notamment sur Symfony
    * API Platform
    * Récemment, le protocole Vulcain (HTTP/2 Server Push)
* Sorti fin 2018 pour la v0.1.0
* Une version gratuite et plusieurs versions payantes (+ de connexions concurrentes, rapidité accrue, ...)



## Infos techniques

* C'est un protocole pour des communications rapides, en temps réel, fiables et économes en batterie
* "Remplacement" des WebSockets API sur une couche plus élevée
* Développé en Go
* Compatible REST & GraphQL
* Utilise les SSE (Server-Sent Events)



## Fonctionnement global

![Fonctionnement Mercure](https://mercure.rocks/static/main.png) <!-- .element width="85%" -->



## Setup rapide

* Lancement d'un serveur Mercure en local via Docker :
```sh
docker run \
    -e MERCURE_PUBLISHER_JWT_KEY='!ChangeMe!' \
    -e MERCURE_SUBSCRIBER_JWT_KEY='!ChangeMe!' \
    -p 80:80 \
    -p 443:443 \
    dunglas/mercure
```

* Accès via la navigateur sur : https://localhost/.well-known/mercure



## Comment ça marche ? Subscriber

* Via l'adresse précédente, erreur : `Missing "topic" parameter.`
* Pourquoi ?
    * Fonctionne avec un système de Subscriber "classique"
    * En tant que Subscriber, on doit écouter un `topic` particulier
* Résolution
    * Ajout de ce `topic` via un simple paramètre GET dans l'URL : https://localhost/.well-known/mercure?topic=https://example.com/message/1
    * Ici, on écoute le `topic` "https://example.com/message/1", mais ce peut être n'importe quoi, même juste "test"



## Comment ça marche ? Publisher (1)

* jwt.io > Debugger
* Partie `Payload`:
```json
{
    "mercure": {
        "publish": ["*"]
    }
}
```
* Partie `Verify Signature`, on met le MDP de la commande Docker, ici `!ChangeMe!`
* On récupère le token
<!-- `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJtZXJjdXJlIjp7InB1Ymxpc2giOlsiKiJdfX0.obDjwCgqtPuIvwBlTxUEmibbBf0zypKCNzNKP7Op2UM` -->



## Comment ça marche ? Publisher (2)

* Test en communication directe sans API
    * Dans un cas réel, c'est l'API qui se charge des appels Mercure

1. Tests via Postman
    * Requête POST sur : `https://localhost/.well-known/mercure`
    * Body de type `x-www-form-urlencoded` :
    * Données du body :
        * topic : `https://example.com/message/1`
        * data (string ou JSON) : `{"header": "BIEEEEERE", "body": "Hum... Une bonne pinte... Ou deux !!"}`
    * Partie `Authorization`, on met `Bearer ${TOKEN}`



2. Tests via CURL
```sh
curl -d 'topic=https://example.com/message/1' \
    -d 'data={"header": "BIEEEEERE", "body": "Hum... Une bonne pinte... Ou deux !!"}' \
    -H 'Authorization: Bearer ${TOKEN}' \
    -X POST https://localhost/.well-known/mercure
```



## Résultat

* Envoi d'un UUID
* Dans notre onglet "Subscriber" `https://localhost/.well-known/mercure?topic=https://example.com/message/1`...



## "Ouais mais... Ton exemple il est nul !"

* On tape directement via le navigateur, donc il tourne constamment
* Ça ne s'utilise ja-mais comme ça dans une appli réelle



## Subscriber très simple en JS

* Utilisation de l'interface EventSource (déf. Mozilla)
```
L'interface EventSource est utilisée afin de recevoir des évènements
envoyés par le serveur.
```
* Ajout d'un objet EventHandler `.onmessage` appelé dès réception d'un message
* Log de la partie data du message reçu dans la console
```js
new EventSource(
    'https://localhost/.well-known/mercure?topic=https://example.com/message/1',
    { withCredentials: false }
).onmessage = function(e) { console.log(e.data); }
```
* Packages NPM existants pour tous les frameworks JS pour utiliser les SSE simplement



## Exemple d'un publisher dans Symfony

* Exemple le plus basique :

```php
// src/Controller/PublishController.php
namespace App\Controller;

use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Mercure\PublisherInterface;
use Symfony\Component\Mercure\Update;

class PublishController
{
    public function __invoke(PublisherInterface $publisher): Response
    {
        $update = new Update(
            'http://example.com/books/1',
            json_encode(['status' => 'OutOfStock'])
        );

        // The Publisher service is an invokable object
        $publisher($update);

        return new Response('published!');
    }
}

```



## Remarques / Questions ?

<svg id="Layer_1" data-name="Layer 1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" viewBox="0 0 422.61 594.72" width="406" height="306" class="illustration styles_illustrationTablet__1DWOa"><defs><linearGradient id="linear-gradient" x1="471.91" y1="448.11" x2="483.86" y2="448.11" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#ecc4d7"></stop><stop offset="0.42" stop-color="#efd4d1"></stop><stop offset="1" stop-color="#f2eac9"></stop></linearGradient><linearGradient id="linear-gradient-2" x1="401.28" y1="390.68" x2="629.44" y2="311.95" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#fff"></stop><stop offset="0" stop-color="#fff" stop-opacity="0"></stop><stop offset="0.99" stop-color="#fff"></stop></linearGradient><linearGradient id="linear-gradient-3" x1="461.61" y1="332.57" x2="453.59" y2="352.99" xlink:href="#linear-gradient"></linearGradient><linearGradient id="linear-gradient-4" x1="441.49" y1="331.58" x2="469.3" y2="331.58" xlink:href="#linear-gradient"></linearGradient><linearGradient id="linear-gradient-5" x1="486.63" y1="310.85" x2="486.63" y2="310.85" xlink:href="#linear-gradient"></linearGradient><linearGradient id="linear-gradient-6" x1="409.29" y1="297.13" x2="423.07" y2="297.13" xlink:href="#linear-gradient"></linearGradient><linearGradient id="linear-gradient-7" x1="265.63" y1="405.63" x2="206.42" y2="429.54" gradientUnits="userSpaceOnUse"><stop offset="0" stop-color="#fff"></stop><stop offset="0" stop-opacity="0"></stop><stop offset="1"></stop></linearGradient></defs><title>32. Baloon</title><path d="M341.24,144.13c-22.17,23.14-29.54,56.75-48.36,82.69-22,30.34-60.06,51.17-68,87.82C216.18,355,248.71,392,281.52,417c15.8,12.05,32.77,23.67,43.05,40.67,6.43,10.64,9.85,22.78,15,34.1,16.34,36.13,52.45,63.7,92.06,65.71s80.11-24.15,90.84-62.32c5.24-18.66,3.93-39.54,14.08-56,13.28-21.59,41.17-28.25,61.34-43.6,38.58-29.34,40.71-95.19,4.11-127-32.09-27.86-85.77-31.51-103.81-70-4.89-10.43-6.28-22.16-10.56-32.85C465.36,110.12,379.46,104.23,341.24,144.13Z" transform="translate(-220.76 -2.28)" fill="#f18700" opacity="0.18"></path><circle cx="190.26" cy="262.46" r="21.51" fill="#3f3d56"></circle><path d="M483.86,427.49s-1.21,27-2.95,32.23.33,7.63-5.13,9-3.54-28.06-3.54-28.06l1.84-11.28Z" transform="translate(-220.76 -2.28)" fill="url(#linear-gradient)"></path><path d="M426.77,435.34l12.63,73.93h10.8l2.7-42.59,2.49,53.47h11.85s10.19-58.57,8.31-69.35a31.51,31.51,0,0,0-3.31-10.17Z" transform="translate(-220.76 -2.28)" fill="#25233a"></path><path d="M434.22,320.08c-.44-5.71-.13-11.78,2.94-16.61a16.52,16.52,0,0,1,11.21-7.36c6.57-1,13,2,19,4.9,8.8,4.32,17.66,8.68,25.4,14.67s14.39,13.84,17.32,23.19a53.22,53.22,0,0,1,2.09,14,54,54,0,0,1-.91,13.2,37.76,37.76,0,0,1-26.83,28c-15,3.9-32.09-1.61-45.66,5.84a6.31,6.31,0,0,1-3,1.1,3.68,3.68,0,0,1-3.18-2.63,8.3,8.3,0,0,1,0-4.34,23.11,23.11,0,0,1,6.39-11.62c4.14-4.05,9.66-6.39,14.18-10a4.39,4.39,0,0,0,1.68-2.12c.54-2-1.54-3.65-3.45-4.39s-4.19-1.4-4.95-3.29c-.62-1.53,0-3.23.43-4.83,1.73-7-2-11.7-5.85-16.89C436.56,334.9,434.78,327.4,434.22,320.08Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M467.52,322.15s6.74,11.27,14.49,18.73,20.95,20.87,12.54,31.05A50,50,0,0,1,475.78,386l-17.07-17.15v-28Z" transform="translate(-220.76 -2.28)" fill="#25233a"></path><path d="M408.36,312.14l16.28-1.21s-4.57,31.6,17.65,41.86,35.89,12.4,37.4,20.32,7.39,53.63,7.39,53.63l-11.19,2.61L475.55,394l.43,44.59s-24.24,13.6-31.22,10.92-21.63-4.91-21.28-27.63,11-38.8-.56-56.09S408.06,320.33,408.36,312.14Z" transform="translate(-220.76 -2.28)" fill="#f18700"></path><path d="M408.36,312.14l16.28-1.21s-4.57,31.6,17.65,41.86,35.89,12.4,37.4,20.32,7.39,53.63,7.39,53.63l-11.19,2.61L475.55,394l.43,44.59s-24.24,13.6-31.22,10.92-21.63-4.91-21.28-27.63,11-38.8-.56-56.09S408.06,320.33,408.36,312.14Z" transform="translate(-220.76 -2.28)" fill="url(#linear-gradient-2)"></path><path d="M447.12,355s.62,9.4,6.66,9.17,6.05-3.25,6.05-3.25l3.84-16.38-16.55,1S449,352.48,447.12,355Z" transform="translate(-220.76 -2.28)" fill="url(#linear-gradient-3)"></path><path d="M447.87,349.84s-.76,4.84,2.35,6.21,8.12-.35,9.33-1.73l.28,6.56,2.8-11.95Z" transform="translate(-220.76 -2.28)" fill="#222a72"></path><path d="M441.94,321.83s-3.49,24.88,9.05,29.91,16.38-8.47,18-14.95-3.07-29.7-13-26.09A27,27,0,0,0,441.94,321.83Z" transform="translate(-220.76 -2.28)" fill="url(#linear-gradient-4)"></path><path d="M486.63,310.85" transform="translate(-220.76 -2.28)" fill="url(#linear-gradient-5)"></path><path d="M412.47,311.84s1.17-8.7,1.2-8.86a4.48,4.48,0,0,0-1.86-4.23c-1.2-.9-2.52-3-2.52-7.85s5.14-10.1,7.26-8,2.13,3.76,4.1,4.07.45,5.31,0,7,2.42,17.11,2.42,17.11Z" transform="translate(-220.76 -2.28)" fill="url(#linear-gradient-6)"></path><polygon points="254.79 391.76 261.29 425.63 255.13 427.07 254.79 391.76" fill="url(#linear-gradient-7)"></polygon><path d="M455.39,520.15s-2.81,27.7,1.8,50.21h3.21l6.84-50.21Z" transform="translate(-220.76 -2.28)" fill="#25233a"></path><path d="M494.55,507.15" transform="translate(-220.76 -2.28)" fill="#222a72"></path><path d="M439.4,509.27l6.44,56.49,2.36-1s4.42-40,4.06-43.86-2.06-11.65-2.06-11.65Z" transform="translate(-220.76 -2.28)" fill="#25233a"></path><path d="M448.2,564.78s1.43,2.42,1.27,4.14c-.12,1.18-8.28,11.3-14.11,16.76-6.3,5.9-12.41,3.72-12.41,3.72-2.28-.23-3.46-5.47-1.72-7a49.53,49.53,0,0,1,12.64-7.88c10.45-4.42,12-8.8,12-8.8Z" transform="translate(-220.76 -2.28)" fill="#25233a"></path><path d="M457.19,570.36a15.45,15.45,0,0,0-.67,6.09c.4,2.93,13,17.27,13,17.27s10.32,6.7,13.94.94-10.68-13.4-13.52-15-9.54-9.29-9.54-9.29Z" transform="translate(-220.76 -2.28)" fill="#25233a"></path><path d="M385,231.49a21.93,21.93,0,0,0,20.48,15.39c5.75,0,12.22-2.19,18.22-9.44,16-19.32-13.45-53.37,26.22-94.54s43.8-114.15-27.45-119c-54.41-3.68-76.67,30.16-82.93,51.34V96.71l38.22,15S392.38,67.35,416.45,73s1.4,45.43-13.79,60.55C369.19,166.88,378.87,212.44,385,231.49Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M385,204.3a22,22,0,0,0,20.48,15.39c5.75,0,12.22-2.61,18.22-9.85,16-19.33-15.49-38.54,24.19-79.71S493.75,7.32,422.5,2.5s-82.93,72.77-82.93,72.77l38.22,15s14.59-44.31,38.66-38.68,1.4,45.42-13.79,60.55C369.19,145.44,378.87,185.25,385,204.3Z" transform="translate(-220.76 -2.28)" fill="#f18700"></path><circle cx="190.26" cy="248.39" r="21.51" fill="#f18700"></circle><circle cx="316.98" cy="256.88" r="9.14" transform="translate(-270.72 432.97) rotate(-64.95)" fill="#3f3d56"></circle><path d="M301.77,247.36a9.35,9.35,0,0,0,10.42,3.18c2.3-.82,4.56-2.65,5.91-6.42,3.58-10-13.12-19.37-3.23-41.58s.94-52-28.22-43.56c-22.28,6.42-26.27,23.17-25.7,32.55l3.11,8.56,17.44.44s-.6-19.83,9.84-21.07,7.15,17.95,3.27,26.2C286.07,223.84,296.55,240.64,301.77,247.36Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M297.83,236.49a9.31,9.31,0,0,0,10.41,3.18c2.31-.82,4.51-2.81,5.85-6.58,3.59-10-11.77-13.15-1.89-35.36s.51-55.72-28.66-47.31S261,191.53,261,191.53l17.44.43s-.59-19.82,9.84-21.06,7.15,17.95,3.27,26.19C283,215.27,292.6,229.77,297.83,236.49Z" transform="translate(-220.76 -2.28)" fill="#f18700"></path><circle cx="314.94" cy="251.25" r="9.14" transform="translate(-299.15 161.74) rotate(-26.08)" fill="#f18700"></circle><path d="M276.7,344.53a9.14,9.14,0,1,1-10.89-7A9.13,9.13,0,0,1,276.7,344.53Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M253.94,335.06a9.32,9.32,0,0,0,9.91,4.52c2.39-.51,4.88-2,6.7-5.58,4.87-9.48-10.46-20.93,2.25-41.65s7.76-51.39-22.26-46.88c-22.93,3.44-29.08,19.52-29.74,28.89l2,8.9L240,286s2-19.73,12.52-19.59,4.73,18.73-.19,26.39C241.46,309.69,249.65,327.72,253.94,335.06Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M251.46,323.77a9.33,9.33,0,0,0,9.91,4.52c2.39-.51,4.83-2.2,6.66-5.75,4.87-9.48-9.95-14.58,2.76-35.3s7.81-55.18-22.21-50.67-27.78,37.79-27.78,37.79L238,277.08s2-19.73,12.52-19.59,4.73,18.73-.19,26.39C239.51,300.79,247.16,316.43,251.46,323.77Z" transform="translate(-220.76 -2.28)" fill="#f18700"></path><circle cx="266.49" cy="340.65" r="9.14" transform="translate(-245.4 18.52) rotate(-4.27)" fill="#f18700"></circle><path d="M544.25,275.84a9.14,9.14,0,1,1-6.88-10.95A9.15,9.15,0,0,1,544.25,275.84Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M527.72,257.56a9.32,9.32,0,0,0,7,8.32c2.37.56,5.27.25,8.44-2.18,8.45-6.49-.51-23.39,19.83-36.69s29-43.15-.09-51.9c-22.2-6.69-34.64,5.22-39.24,13.41l-2,8.88,14.42,9.82s10.25-17,19.69-12.36-3.73,18.95-11.46,23.78C527.28,229.28,527,249.08,527.72,257.56Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M530.3,246.29a9.31,9.31,0,0,0,7,8.32c2.38.57,5.32.08,8.49-2.35,8.45-6.49-2.77-17.44,17.58-30.74S594,175,565,166.22s-41.27,22.3-41.27,22.3l14.42,9.82s10.25-17,19.69-12.37-3.73,19-11.45,23.79C529.31,220.4,529.55,237.82,530.3,246.29Z" transform="translate(-220.76 -2.28)" fill="#f18700"></path><circle cx="536.67" cy="267.97" r="9.14" transform="translate(-131.52 665.24) rotate(-68.3)" fill="#f18700"></circle><path d="M590.66,357.61a6.79,6.79,0,1,1-1.63-9.47A6.79,6.79,0,0,1,590.66,357.61Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M584.46,340.37a6.93,6.93,0,0,0,2.49,7.7,7.22,7.22,0,0,0,6.42.89c7.65-2.07,6.26-16.23,24-19.63s32.13-21.48,14.61-35.72c-13.37-10.87-25.29-6.2-30.77-1.87l-3.91,5.53,7.14,10.84s11.85-8.78,17-2.94-7.92,12-14.6,13.12C592.16,320.79,586.35,334.32,584.46,340.37Z" transform="translate(-220.76 -2.28)" fill="#3f3d56"></path><path d="M589.42,333.34a6.94,6.94,0,0,0,2.49,7.71c1.47,1.06,3.63,1.56,6.49.78,7.65-2.07,3-12.77,20.79-16.16s34.23-23.35,16.71-37.59-34.68,3.66-34.68,3.66l7.14,10.83s11.85-8.78,17-2.93-7.92,12-14.6,13.12C596.07,315.26,591.31,327.3,589.42,333.34Z" transform="translate(-220.76 -2.28)" fill="#f18700"></path><circle cx="587.68" cy="350.06" r="6.8" transform="translate(-254.25 634.23) rotate(-55.54)" fill="#f18700"></circle><path d="M411.61,538.23a.7.7,0,0,1-.36-.1.71.71,0,0,1-.26-1,238.22,238.22,0,0,0,18.45-43.52c7.42-23.55,14.42-58.7,5.6-92.44-17-64.95-20.94-104.83-21-105.23a.72.72,0,0,1,.65-.78.71.71,0,0,1,.77.64c0,.4,4,40.18,20.94,105,8.91,34.08,1.86,69.53-5.63,93.27a240.84,240.84,0,0,1-18.56,43.77A.72.72,0,0,1,411.61,538.23Z" transform="translate(-220.76 -2.28)" fill="#fff"></path></svg>


<!--
https://mercure.rocks/docs/getting-started

https://blog.eleven-labs.com/fr/a-la-decouverte-de-mercure/
-->