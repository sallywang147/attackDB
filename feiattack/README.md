**[Fei Protocol Attack](https://certik.medium.com/fei-protocol-incident-analysis-8527440696cc)**

<img width="849" alt="Screen Shot 2023-01-12 at 9 24 17 AM" src="https://user-images.githubusercontent.com/60257613/212091999-5b05cc12-2f4e-4f39-9008-c3d091d74ef5.png">

The root cause is in the `borrow()` function. This attack was due to a design flaw in the FeiProtocl that failed to follow the check-effect-interaction pattern and thus allow the attacker to make a reentrant call before the borrow records are updated. In the “borrow()” function, the following code is implemented:<img width="688" alt="Screen Shot 2023-01-12 at 9 28 22 AM" src="https://user-images.githubusercontent.com/60257613/212092983-f3f0a568-37e7-4b1b-b7e7-17d2768d3628.png">

[Here](https://github.com/fei-protocol/fei-protocol-core/pull/98) is the official fix
