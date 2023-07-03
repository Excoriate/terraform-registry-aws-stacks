# Changelog

## [1.3.1](https://github.com/Excoriate/terraform-registry-aws-stacks/compare/v1.3.0...v1.3.1) (2023-07-03)


### Docs

* add listed new module in main readme.md ([2efcb09](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/2efcb0980cf604d46d0e15a3c771ba920e4762a6))

## [1.3.0](https://github.com/Excoriate/terraform-registry-aws-stacks/compare/v1.2.0...v1.3.0) (2023-07-03)


### Features

* add identity provider as part of the module ([d3c576c](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/d3c576c5fdf757cedeea96af9227cf9ed88a2a25))
* add ses configuration for auth stack ([b164860](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/b1648602f381ecab83965b16cabf5ca2ac1d4636))
* add user pool client configuration ([e3d225b](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/e3d225bd499ef476a0886c093d7e1ccdc28682f2))
* add user pool domain integration ([a160650](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/a1606504672d3d998df5f5b66e321ae7421a8689))


### Refactoring

* add prefix for user pool related input variables ([945433b](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/945433bddd8ec931fbc264e502df75f142a11535))


### Docs

* add generated terraform-docs ([cf44847](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/cf44847d9bed3856654b97ef45fabdf629d42b4c))

## [1.2.0](https://github.com/Excoriate/terraform-registry-aws-stacks/compare/v1.1.0...v1.2.0) (2023-05-21)


### Features

* add support for built-in ecr container registry ([f1c02bc](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/f1c02bcb4253e93d9e019828c1a138954087e27a))

## [1.1.0](https://github.com/Excoriate/terraform-registry-aws-stacks/compare/v1.0.0...v1.1.0) (2023-05-21)


### Features

* add basic skeleton ([6467b23](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/6467b2302d7d92cad4bfa615c8737ef9bacf1129))
* add certificate ([acd559b](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/acd559bd1a5a7d351f058c156851ced072ac4f9f))
* add certificate ([7464ee3](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/7464ee3ac71dc90105f4d10ccc7e09f310bcec2a))
* add certificate ([9a5d8ed](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/9a5d8ed9e09a130449d7d6e3c858fbbde6e9477f))
* add container definition module ([8d4c905](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/8d4c905a3ca57e93aa95ed0671a8eb55579f94aa))
* add default path for stack alb ([a137ebf](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/a137ebfa32c70f76b772ea0f4d240cf45e5dff7d))
* add ecs task role modules ([30f489c](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/30f489cfa48962a0178b3c8ebe99ed8ecaf881b5))
* add ecs-task definition module integration ([ba2ee95](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/ba2ee95261d78945ec893be1475ce1808eb3a57b))
* add environment dns creation capability ([2113ed0](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/2113ed0e1510d96e0a1ab346b36fc0b8828a8ecd))
* add lookup module integration, add sg ([69c72c0](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/69c72c0d2483fb87deae684abf0e67691359660c))
* add multi-account capability for child zones ([cbb8bde](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/cbb8bdea33688be276fb0e95ff7eb63baf744941))
* add stack for alb ([2bddb9e](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/2bddb9ef17a331b4686923d4e2bf8883d0c6bc3a))
* add stack for aws secrets manager ([c7c955b](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/c7c955bf35cadd583ac413e0b29dda33b867c9dd))
* add stack module for dns delegation ([ff63bd5](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/ff63bd5bfe9515bad35335bc35930d6a0020cf07))
* add support for certificates ([ddb09e2](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/ddb09e2f377dee4495f7bfd4501307c3bf668f12))
* add support for force deletion in ecr module, add release-please ([7962089](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/796208928ef5bc82b7e5fc24af9ae9cd5ae5d2a5))
* add target group configuration ([699f396](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/699f396551e8eef88ed423b436232f6360af4d40))
* add test stack version ([728d6b4](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/728d6b4530554487ab941ce93926e8282a733811))
* add test stack version ([89c2d1a](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/89c2d1aee5e2e5fdc634a5f2034d2a69c032df74))
* add test stack version ([11695fa](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/11695fa4140dfbc9bcf3b7c24b4a52b83db78ec7))
* add test stack version ([7458849](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/74588496c8c0936f9fa7c1bab50568f82effcca4))
* add working auto-scaler version, no attachment ([b00901b](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/b00901b52dd1b09263e7de4edc0251315089dede))
* add working ecs log group, and sg ([9bf750e](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/9bf750e5b5a5da6a418dc6e2755680d5e82ea71e))
* add working stack ([cc764d9](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/cc764d9f2919c8312b39a74371dd4e74bbd542b9))
* first commit ([41e4a59](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/41e4a59dd59d5cf6346bd962649013cd58335444))


### Bug Fixes

* add backend service support, and custom port ([d7d1cc3](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/d7d1cc3d3dedd3f60adc879d3c19a24d70c185ee))
* add explicit dependncy to listener ([9c69a88](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/9c69a8897ed40bb20b465307c801cffc17d0719e))
* add fix for non-passed ns records ([54caa6d](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/54caa6d4d25382421411c033a8184cbb12243668))
* add fixed containers module version, for non-managed tf option ([d42b82a](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/d42b82a2159250b98625c53c92306c1fa061f6a7))
* add fixed version of dnsa module ([c3d93ae](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/c3d93ae5b4aade89d31290f46ea2d73ac0763868))
* add fixed version of dnsa module ([b68a60c](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/b68a60c650970f82e315ee2c425db1f305beae57))
* add new version, add acm validation ([6de1476](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/6de1476d8a8b1f6c24d02cd4112334af452dffc6))
* alb target group health-checks ([7fcbc6e](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/7fcbc6e2067eb7b5952769bc2b35e9dcd072b443))
* manage null on conditional tg creation ([e4a10c8](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/e4a10c8fab73c171b806417cd0e4835908476736))
* manage null on conditional tg creation ([6404c82](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/6404c8265b5ae1e79647e69d7b5db96fbb3e034c))
* manage null on conditional tg creation ([b3d39b5](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/b3d39b5a45fba584c2a477ed4db164c87aa54c37))
* manage null on conditional tg creation ([f0d6d5f](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/f0d6d5f6fb6d74f671c3245b7eb1f90b8c4311ec))


### Docs

* update documentation ([9dba5d1](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/9dba5d102da01dfe54be0e10a9bc9bd3437d10f2))


### Other

* add badges ([5f6cd0a](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/5f6cd0a5b8516aa88e3481fef932bd3c8370d61b))
* add badges ([0c0a770](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/0c0a770e6bf94f740c68d061df5327e72bfdf5a3))
* add badges ([b0bfdd4](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/b0bfdd49fd55bb73fb8eef5e7a775790e4ea93f8))
* update module ([7017b63](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/7017b634b56b10a529913a61fde8a8ad646fb9d4))


### Refactoring

* add output values ([3f2f032](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/3f2f032bab7bd24c1035ad75b1182b649ecf10a4))
* expose the manage outside of terraform to the ecs-task module ([f319a51](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/f319a51fb204c97aea9a8a2a165fea85a38d3f2c))
* expose the manage outside of terraform to the ecs-task module ([b89669b](https://github.com/Excoriate/terraform-registry-aws-stacks/commit/b89669b6c8ab5e81a98d9b364599a8daaeb331ac))
