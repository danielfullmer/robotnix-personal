{
  description = "My (danielfullmer's) personal robotnix configurations";

  inputs.robotnix.url = "github:danielfullmer/robotnix";
  inputs.nixpkgs.follows = "robotnix/nixpkgs";

  outputs = { self, robotnix, nixpkgs }: let
    myDomain = "daniel.fullmer.me";
    common = { config, pkgs, lib, ... }: {
      #imports = [ self.robotnixModules.google ];

      # A _string_ of the path for the key store.
      signing.keyStorePath = "/var/secrets/android-keys";
      signing.enable = true;

      ccache.enable = true;

      apps = {
        updater.enable = true;
        updater.url = "https://${myDomain}/android/";

        seedvault.enable = true;
        fdroid.enable = true;

        # See the NixOS module under nixos/ subdir
        auditor.enable = true;
        auditor.domain = "attestation.${myDomain}";
      };

      # Can't access paths under keyStorePath in restricted mode.
      # TODO: User shouldn't have to figure this out themselves
      apps.prebuilt.F-Droid.fingerprint = lib.mkIf config.signing.enable "440B1449D705B85191E427C1ACF245B48854CACF1240AA358F15E4D022BA4A7F";
      apps.prebuilt.Auditor.fingerprint = lib.mkIf config.signing.enable "30E3A2C19024A208DF0D4FE0633AE3663B22AD4868F446B1AC36D526CA8E95FA";
      apps.prebuilt.chromium.fingerprint = lib.mkIf config.signing.enable "33AAE6CE0121A499A533DD94C010BF09BA97A3B61FC2C0A0D192F6A922EA95C3";
      apps.prebuilt.vanadium.fingerprint = lib.mkIf config.signing.enable "7B8E48EA0A4E50F08D01DD519A8F54A93489B78395ABA733EFF9BB8C53B97132";

      hosts = pkgs.fetchFromGitHub {
        owner = "StevenBlack";
        repo = "hosts";
        rev = "3.4.2";
        sha256 = "sha256-+Yz5/UOXu+/5G1cfm0bhBaXQlccSowlACWhKSv0BgA8=";
      } + "/hosts";

      microg.enable = true;
      #google.fi.enable = true;

      apps.fdroid.additionalRepos = {
        playmaker = {
          enable = true;
          url = "https://fdroid.${myDomain}";
          pubkey = "308204e7308202cfa003020102020426abb91d300d06092a864886f70d01010b050030243110300e060355040b1307462d44726f69643110300e0603550403130762656c6c6d616e301e170d3139303531383230343734345a170d3436313030333230343734345a30243110300e060355040b1307462d44726f69643110300e0603550403130762656c6c6d616e30820222300d06092a864886f70d01010105000382020f003082020a0282020100adaa800eecc1430a73ab68cdac5d343e7e9d23cd9551a7107c719d51c1ab6e78b1b4ca8cb7454439e312de0316d61b7b6eddeeb9ca2b0851857e88c4440b1990a156ee5ea80aba8cd2fd790fdbac1ea809b5f35d2de081c655c16a99bcfb70338f463a8c1399d402cab86bba00c550aeced23e65e921c8e15619e9917e167d32f4a4ee4950acf7842afd6ad16af7227508aeecfb235312705caf7344e31dd2a8500c373cbbb8108360d899f9d88cdc03f5f437f5d0d13b510c1a362b5ff4d2639b6a06a7b1d918d75ef682ab2efb94345d4a792275a16e06430a52b0a7ebc03518381c6e0a9a854c582886fa146e0a2f430c9947aea3838a2c214cd06def9c4381a34ecb11e658d2c4a94f95d3c6ba9059e72e10c92d0f6a0b6d909226e133b02de5adad53fba42fb9c5d09335c2bd3793a271e9f048a0179741dd0e33c2b4a08b1f6dfc9edc56213f38cf9705fef07b4e8fd40ecc4bddb2b16a6039f319c81138b655e0033cd823566ceb39f08d14d6c21eb23c7d24a7290cb3e3d43093c5d77ea0c013ea1e6a55911f0dc4c0d0815673842f3c24f19c4ae5cfc836b407cebd4e36eed9389cd3abba40e008bb5fdfc2a74f96fb0bf9b23f3d971491f199ea20a111e898423caf46ad3da8784b260be2785ed979b653048f6404f9a729d9153a6921a763aab035959d18352030dbf436452a443a3602913ff22d00810971f2390203010001a321301f301d0603551d0e04160414234ec5a5137a9df3e575dd74d09a00b7ffd676c3300d06092a864886f70d01010b050003820201000c37f2860cd3f1cc446ad656fff1a3444b8975ff7fcfe97f731517af9d98323dee8ed088a1ad31375d927ac52e2891ae6695ae28bd7ad7f083ab53b362046a361b83a54f326aadd0ec61f9fbefa0ddb5afdc793d8fa9970605b583463a92dad8046c8cde7b52f5aca3de5610136b83d6dd5bed6de5e96c25502a7ca451fd00453fe8a4be920da185e75a80b1df75850f440b814183ca22785c2ca1bccbceedbcfca7defceaa9ab2b61bf838e631df65d7733d39d8e28357e8452f70e8a65afaa20384f3f70c018a9274e16cc51bfba6cb6bbb5a1ea6cf1c38ebfd63123b7efd29981bf36dffa395090f1df37f23864ed666442f73b4685d619d9f734f278277c1397f6a4eb0d137c0255def8b7fe9f6676e1a0add9ed4b3e28ffa3af560419a2c5737506df5807ebfbc73c621539d5bb114e405aab7681a9d6c2d492cea902fbc4889c33383ae4fa817e442e1db1634186e6e66234ad4120e67231917cfd29afc48793bf9a95550b4836f5704502b071afc5265ccad0850fdcf6d0541ccfec84d2036ca0f8768390c641bb8b962d3312738a306732f4adc322840965ff4d1a5370c0ca2ca2cd42c524ca6023d40d5550832b7b3fb73b3479484520c8692984c85ccb9ce1e9001f9d9d07a16a0b9d7bff305d6fd30fd7a682f96423effcc32d2463c20c91b4574f6ec2968bfbea59d4258523b9b51e7b60d5d2362889a3f86fd2";
        };
        Robotnix = {
          enable = true;
          url = "https://${myDomain}/${config.device}/fdroid/repo";
          pubkey = "308204e7308202cfa00302010202045bbd0632300d06092a864886f70d01010b050030243110300e060355040b1307462d44726f69643110300e0603550403130762656c6c6d616e301e170d3139303831363232323134325a170d3437303130313232323134325a30243110300e060355040b1307462d44726f69643110300e0603550403130762656c6c6d616e30820222300d06092a864886f70d01010105000382020f003082020a028202010098d534dc3456e2525385e0c02bb0c6297ae1a0c0f9daa7bce30109abc6fcaa7acb9dda24341ab3e818b68313129de6645c521fcb77b83c3760efabf6373c3a46353aedd1ce2130578c92f12d6a3ce698b7a1f6824bab46c4fbb5b99a0a7bc0c7ce83b3a8ec5d3da8a3f4439e9770cb4e4412ec5fa9cbb36d84925bc6fb56a494e69200b45d59a0ce52840defe995ca82d3d0c807b630a1d129439b0d6d135a58e789b69e91ba0d9ec65294494d5d63d1cb7ce0849f810a8f940698ee6bdbf29f7aa4eb76329e039e0c09edd05cd3da020c19baf9bab67ee59b0eae5ce29950e0d4ab4b9a4b358f80d37a57c0ed09498666b79b9e77cca0842c6826dbe7e2f7d3a0bfad616c609d3f948803be031100aec90abd227e84675d555290536d05302067bdeddcdf4d64a1abc17e7cfa5d5eae08c018cc3877d63d29d4cd425b162f0af7106deecea5a7e8a1d6bd5afd12c2761f4a26451e3f85646582ffb3738ba18a7d5a69a2b6dabd9a3f6689e5dc8f06e4409e00d723c277925aa9b69c123e227f6ff5164df747cfe661a250b4c123cf0dcf87a2ae9108d9ac21db7e933e8c3082208a9842d9d47474581bc31b853f8f48a54663a6a9d272a6de0068444314fbd3085a43cea4512923e6b85087d643e6de88e6e99640996854fbf867be53053558c154071929a0cc3d5182aec9555f52bee71e4eac408031f7dcabdd2811f3db010203010001a321301f301d0603551d0e041604146512cf370744fba93fac225689e8130ac0f1e01f300d06092a864886f70d01010b050003820201002c59f96e42ea0d769eafb25ed3ce8f37e99b6c5745ff35c6d11754eb1802aef5effdc8a78af9d54715ad9a1ecfbe7417c72d88a4ab5c8d392c3b7d5cd33817ce5e54e25f1a8a10b596854121ebbac9fd9d93cf88d12d4674e338ad50711db54c856314c3ef6d3cdcf979f19c8ce30c7717a374d7cc1d2d033f456de0e668a81a11465f5b80ab31e5282a38117c58c99262c732c206222e50e947b241d34324cb79ea3b98f3c6bc2f1f6f7185937bc70bd86ad33ea7f18c0df2e2620cb31f6b3bc9b59f21bcdcffbd4e3dbd5f0e7c33491e8cde2704a80bece6635bdbf7c3c3581d24a5cae729a5866ece0a0e6d094610de3d274de06aeada48dac6562a9e6299c1206816722bd3b3f261a5f90d731610c495d3e1e6cad8239bf6c54fb0eaf7e156dbd1dcea4633a8b2b5561febc9e8e962454b66bd2fe1c953fd48481990ce40557632d4b9195376fae5ab7fb8575dde793dc9bc6a32fd88cdd774c03747d258a9ed4bbf881a640aff3e5a913bb60845dbf385cc6f902e2f29ea63ca7588b445a94abde6acb1ea6a2c1b48ed549bb79964a4a05221e9683427ddb30f44124015d09cf53130634963c4e3e70ced5739b7a041b55dfa8a7f6ac4fcc0650f36a35c23c5ae398f34f6c1cb61368e69b66b0a0703594a7dab98bdf33e7d9a8cf477824afe5f8a1b8d5bd805a638d959f818f27932a3579e08a30d3bf63d21babb445d";
        };
      };
    };
  in {
    robotnixConfigurations."marlin" = robotnix.lib.robotnixSystem ({ config, pkgs, lib, ... }: {
      imports = [ common ];
      device = "marlin";
      flavor = "vanilla";
      androidVersion = 10;
      signing.avb.verityCert = ./marlin-verity.x509.pem;
    });

    robotnixConfigurations."crosshatch" = robotnix.lib.robotnixSystem ({ config, pkgs, ... }: {
      imports = [ common ];
      device = "crosshatch";
      flavor = "grapheneos";
      signing.avb.fingerprint = "F7B29168803BA73C31641D2770C2A84D4FF68C157F0B8BFE0BDC1958D4310491";
      envVars.PLATFORM_SECURITY_PATCH = "2021-11-05"; # I messed up on an earlier update and PLATFORM_SECURITY_PATCH was 2021-11-05 instead of 2021-11-01
    });

    robotnixConfigurations."sunfish" = robotnix.lib.robotnixSystem ({ config, pkgs, ... }: {
      imports = [ common ];
      device = "sunfish";
      flavor = "vanilla";
      signing.avb.fingerprint = "3795C68BE9F9FD2152ABBE6D3CDEAED70133F3894DE3038028E58509EABAEE74";
    });

    robotnixModules.google = import ./google.nix;

    packages.x86_64-linux = {
      otaDir = nixpkgs.legacyPackages.x86_64-linux.symlinkJoin {
        name = "robotnix-ota";
        paths = (with self.robotnixConfigurations; map (c: c.otaDir) [
          #marlin
          crosshatch
          sunfish
        ]);
      };
    };
  };
}
