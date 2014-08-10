# TODO

* Add some integration tests that actually run some packer builds
* Add an option to Packer::Config#validate to run the configuration through packer's `validate` command
* Add missing builders, provisioners and post-processors. I only implemented the builders, provisioners and post-processors that I'm currently using.
* Refactor the child classes. I get the feeling that these could be implemented in some better, templated, type of way
* Look in to something like VCR to drive the tests of the child classes -- there's a lot of repetitive testing that could be done on them.