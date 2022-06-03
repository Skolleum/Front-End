# Capstone Flutter Mobile-App
- Flutter
- Smart Contracts (https://ethereum.org/en/developers/docs/programming-languages/dart/)
- Ganache (https://trufflesuite.com/ganache/)

## Why Ganache?
- Because Ethereum gas prices are expensive, it's decided Ganache test environment would be the closest exposure to the real web3 transactions on ethereum network.
- You do not need to pay any amount of money to run this application, only Ganache desktop app should be running simultaneously with Flutter app.

## How to run?

Truffle:
- Open ganache and add truffle.js file to ganache test project.
- in the project directory run:
  - truffle migrate

Flutter:
- flutter pub get 
- flutter run

# App flow

- Ganache server must be running and using truffle-config.js
- in the project folder consequently run: truffle migrate and flutter run
- on the login page, enter ganache test address's private key to continue.

## Video - Image
https://user-images.githubusercontent.com/46297574/171870913-6ea07eea-5ab7-4b02-8962-077dd40a5233.mov
<p align="right">(<a href="#top">back to top</a>)</p>

<img width="1198" alt="Screenshot 2022-06-03 at 17 12 34" src="https://user-images.githubusercontent.com/46297574/171871406-b9bcf1cb-9e0c-4627-a18e-079e3cd39742.png">
<img width="1198" alt="Screenshot 2022-06-03 at 17 12 10" src="https://user-images.githubusercontent.com/46297574/171871426-eb1e0505-0048-4cca-9b5b-cae7ac57335d.png">
<img width="1198" alt="Screenshot 2022-06-03 at 17 12 24" src="https://user-images.githubusercontent.com/46297574/171871429-9c0aa220-396c-48a1-bb24-10830ecece30.png">
