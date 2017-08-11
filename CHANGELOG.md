# Change Log

## [v1.5.1](https://github.com/nubisproject/nubis-terraform/tree/v1.5.1) (2017-08-11)
[Full Changelog](https://github.com/nubisproject/nubis-terraform/compare/v1.5.0...v1.5.1)

**Closed issues:**

- \[load\_balancer\] Expose the source\_security\_group\_id of the ELB [\#93](https://github.com/nubisproject/nubis-terraform/issues/93)
- \[load\_balancer\] Security Groups are unnamed [\#91](https://github.com/nubisproject/nubis-terraform/issues/91)
- \[elb\] Allow creating of internal ELBs [\#89](https://github.com/nubisproject/nubis-terraform/issues/89)
- \[worker\] Add purpose tag [\#86](https://github.com/nubisproject/nubis-terraform/issues/86)
- \[database\] Monitor host should support nubis\_{sudo,user}\_groups [\#84](https://github.com/nubisproject/nubis-terraform/issues/84)

**Merged pull requests:**

- Update CHANGELOG for v1.5.1 release \[skip ci\] [\#98](https://github.com/nubisproject/nubis-terraform/pull/98) ([tinnightcap](https://github.com/tinnightcap))
- \[load\_balancer\] expose the source security group id of the ELB [\#94](https://github.com/nubisproject/nubis-terraform/pull/94) ([gozer](https://github.com/gozer))
- Correctly name ELB security groups [\#92](https://github.com/nubisproject/nubis-terraform/pull/92) ([gozer](https://github.com/gozer))
- \[load-balancer\] Add 'internal' variable [\#90](https://github.com/nubisproject/nubis-terraform/pull/90) ([gozer](https://github.com/gozer))
- Add purpose tag [\#87](https://github.com/nubisproject/nubis-terraform/pull/87) ([limed](https://github.com/limed))
- Add nubis\_sudo\_groups and nubis\_user\_groups [\#85](https://github.com/nubisproject/nubis-terraform/pull/85) ([gozer](https://github.com/gozer))

## [v1.5.0](https://github.com/nubisproject/nubis-terraform/tree/v1.5.0) (2017-06-24)
[Full Changelog](https://github.com/nubisproject/nubis-terraform/compare/v1.4.2...v1.5.0)

**Closed issues:**

- \[database\] Allow specifiying access to IP CIDRs [\#77](https://github.com/nubisproject/nubis-terraform/issues/77)
- Create static\_website module [\#44](https://github.com/nubisproject/nubis-terraform/issues/44)
- \[worker\] Add CPU Usage based autoscaling up/down [\#1](https://github.com/nubisproject/nubis-terraform/issues/1)
- Tag v1.5.0 release [\#80](https://github.com/nubisproject/nubis-terraform/issues/80)

**Merged pull requests:**

- Merge v1.5.0 release into develop. \[skip ci\] [\#82](https://github.com/nubisproject/nubis-terraform/pull/82) ([tinnightcap](https://github.com/tinnightcap))
- Update CHANGELOG for v1.5.0 release \[skip ci\] [\#81](https://github.com/nubisproject/nubis-terraform/pull/81) ([tinnightcap](https://github.com/tinnightcap))
- \[info\] Add sso\_security\_group [\#79](https://github.com/nubisproject/nubis-terraform/pull/79) ([gozer](https://github.com/gozer))
- \[database\] Add client\_ip\_cidr option [\#78](https://github.com/nubisproject/nubis-terraform/pull/78) ([gozer](https://github.com/gozer))

## [v1.4.2](https://github.com/nubisproject/nubis-terraform/tree/v1.4.2) (2017-05-03)
[Full Changelog](https://github.com/nubisproject/nubis-terraform/compare/v1.4.1...v1.4.2)

**Closed issues:**

- \[worker\] Expose technical\_owner in user-data [\#67](https://github.com/nubisproject/nubis-terraform/issues/67)
- Get rid of NUBIS\_MIGRATE [\#65](https://github.com/nubisproject/nubis-terraform/issues/65)
- \[bucket\] Missing bucket object ACL permissions [\#63](https://github.com/nubisproject/nubis-terraform/issues/63)
- Tag sensitive outputs [\#46](https://github.com/nubisproject/nubis-terraform/issues/46)
- Devise a standard mechanism so modules can depend on one another. [\#7](https://github.com/nubisproject/nubis-terraform/issues/7)
- Tag v1.4.2 release [\#73](https://github.com/nubisproject/nubis-terraform/issues/73)
- Tag v1.4.2 release [\#70](https://github.com/nubisproject/nubis-terraform/issues/70)

**Merged pull requests:**

- Merge v1.4.2 release into develop. \[skip ci\] [\#76](https://github.com/nubisproject/nubis-terraform/pull/76) ([tinnightcap](https://github.com/tinnightcap))
- Update CHANGELOG for v1.4.2 release \[skip ci\] [\#75](https://github.com/nubisproject/nubis-terraform/pull/75) ([tinnightcap](https://github.com/tinnightcap))
- Merge v1.4.2 release into develop. \[skip ci\] [\#72](https://github.com/nubisproject/nubis-terraform/pull/72) ([tinnightcap](https://github.com/tinnightcap))
- Update CHANGELOG for v1.4.2 release \[skip ci\] [\#71](https://github.com/nubisproject/nubis-terraform/pull/71) ([tinnightcap](https://github.com/tinnightcap))
- Add NUBIS\_TECHNICAL\_OWNER to instances user-data [\#68](https://github.com/nubisproject/nubis-terraform/pull/68) ([gozer](https://github.com/gozer))
- Get rid of NUBIS\_MIGRATE [\#66](https://github.com/nubisproject/nubis-terraform/pull/66) ([gozer](https://github.com/gozer))
- \[bucket\] Add s3:\*Acl permissions for consumers [\#64](https://github.com/nubisproject/nubis-terraform/pull/64) ([gozer](https://github.com/gozer))

## [v1.4.1](https://github.com/nubisproject/nubis-terraform/tree/v1.4.1) (2017-04-11)
[Full Changelog](https://github.com/nubisproject/nubis-terraform/compare/v1.4.0...v1.4.1)

**Closed issues:**

- Tag v1.4.1 release [\#60](https://github.com/nubisproject/nubis-terraform/issues/60)

**Merged pull requests:**

- Merge v1.4.1 release into develop. \[skip ci\] [\#62](https://github.com/nubisproject/nubis-terraform/pull/62) ([tinnightcap](https://github.com/tinnightcap))
- Update CHANGELOG for v1.4.1 release \[skip ci\] [\#61](https://github.com/nubisproject/nubis-terraform/pull/61) ([tinnightcap](https://github.com/tinnightcap))

## [v1.4.0](https://github.com/nubisproject/nubis-terraform/tree/v1.4.0) (2017-04-05)
[Full Changelog](https://github.com/nubisproject/nubis-terraform/compare/v1.3.0...v1.4.0)

**Closed issues:**

- \[bucket\] Enable website and allow specifiying the index document [\#58](https://github.com/nubisproject/nubis-terraform/issues/58)
- \[bucket\] Allow specifiying the default ACL [\#57](https://github.com/nubisproject/nubis-terraform/issues/57)
- \[worker\] Add an enable flag to make the module optionnally enableable [\#50](https://github.com/nubisproject/nubis-terraform/issues/50)
- \[database\] Add monitoring option to bring back db-admin host [\#49](https://github.com/nubisproject/nubis-terraform/issues/49)
- set enable\_monitoring=false on all aws\_launch\_configuration resources [\#47](https://github.com/nubisproject/nubis-terraform/issues/47)
- Convert over to Terraform 0.8.x [\#38](https://github.com/nubisproject/nubis-terraform/issues/38)
- Support for newer versions of Terraform [\#37](https://github.com/nubisproject/nubis-terraform/issues/37)
- \[load\_balancer\] Send logs to the ELB bucket [\#8](https://github.com/nubisproject/nubis-terraform/issues/8)
- Tag v1.4.0 release [\#33](https://github.com/nubisproject/nubis-terraform/issues/33)

**Merged pull requests:**

- \[bucket\] Add acl and website\_index options [\#59](https://github.com/nubisproject/nubis-terraform/pull/59) ([gozer](https://github.com/gozer))
- Merge v1.4.0 release into develop. \[skip ci\] [\#54](https://github.com/nubisproject/nubis-terraform/pull/54) ([tinnightcap](https://github.com/tinnightcap))
- Update CHANGELOG for v1.4.0 release \[skip ci\] [\#53](https://github.com/nubisproject/nubis-terraform/pull/53) ([tinnightcap](https://github.com/tinnightcap))
- \[database\] Add a monitoring \(default false\) paramater to launch a db-admin host [\#52](https://github.com/nubisproject/nubis-terraform/pull/52) ([gozer](https://github.com/gozer))
- Add an enable \(default true\) to worker module [\#51](https://github.com/nubisproject/nubis-terraform/pull/51) ([gozer](https://github.com/gozer))
- Disabled detailed monitoring for ASGs [\#48](https://github.com/nubisproject/nubis-terraform/pull/48) ([gozer](https://github.com/gozer))
- \[worker\] Add a needed security\_group\_custom to allow for custom generated security\_groups [\#43](https://github.com/nubisproject/nubis-terraform/pull/43) ([gozer](https://github.com/gozer))
- add public option for workers [\#42](https://github.com/nubisproject/nubis-terraform/pull/42) ([gozer](https://github.com/gozer))
- Fix info outputs for TF 0.8 [\#41](https://github.com/nubisproject/nubis-terraform/pull/41) ([gozer](https://github.com/gozer))
- Convert to TF 0.8 friendly [\#39](https://github.com/nubisproject/nubis-terraform/pull/39) ([gozer](https://github.com/gozer))
- Ship logs to the account's ELB bucket [\#35](https://github.com/nubisproject/nubis-terraform/pull/35) ([gozer](https://github.com/gozer))
- Ship logs to the account's ELB bucket [\#34](https://github.com/nubisproject/nubis-terraform/pull/34) ([gozer](https://github.com/gozer))

## [v1.3.0](https://github.com/nubisproject/nubis-terraform/tree/v1.3.0) (2017-01-20)
**Closed issues:**

- \[database\] Allow self crosstalk for DB replication [\#31](https://github.com/nubisproject/nubis-terraform/issues/31)
- \[bucket\] Support granting access to multiple roles [\#29](https://github.com/nubisproject/nubis-terraform/issues/29)
- \[bucket\] Use maximum length possible for randomness [\#27](https://github.com/nubisproject/nubis-terraform/issues/27)
- \[database\] When specifying multi-AZ, it also should apply to slaves [\#25](https://github.com/nubisproject/nubis-terraform/issues/25)
- ELB timeouts are not defaults [\#21](https://github.com/nubisproject/nubis-terraform/issues/21)
- \[autoscaling\] Enable CloudWatch metrics [\#19](https://github.com/nubisproject/nubis-terraform/issues/19)
- Shorten ELB names until we can find a real good fix for the 32-character limit [\#17](https://github.com/nubisproject/nubis-terraform/issues/17)
- \[load\_balancers\] Load balancers in a VPC support IPv4 addresses only [\#14](https://github.com/nubisproject/nubis-terraform/issues/14)
- \[worker\] Inject ldap group information to user data [\#12](https://github.com/nubisproject/nubis-terraform/issues/12)
- \[load\_balancer\] Support custom SSL certificates [\#10](https://github.com/nubisproject/nubis-terraform/issues/10)
- \[load\_balancer\] Support non-default SSL certificate [\#9](https://github.com/nubisproject/nubis-terraform/issues/9)
- Tag v1.3.0 release [\#24](https://github.com/nubisproject/nubis-terraform/issues/24)

**Merged pull requests:**

- Allow self traffic between the same DB instances [\#32](https://github.com/nubisproject/nubis-terraform/pull/32) ([gozer](https://github.com/gozer))
- Add support for multiple roles, must pass in role\_cnt \(sic\) [\#30](https://github.com/nubisproject/nubis-terraform/pull/30) ([gozer](https://github.com/gozer))
- Use the full available randomness before truncating down [\#28](https://github.com/nubisproject/nubis-terraform/pull/28) ([gozer](https://github.com/gozer))
- Propagate the multi-az choice to DB replicas as well [\#26](https://github.com/nubisproject/nubis-terraform/pull/26) ([gozer](https://github.com/gozer))
- use relative path [\#23](https://github.com/nubisproject/nubis-terraform/pull/23) ([gozer](https://github.com/gozer))
- Lower ELB idle\_timeout/connection\_draining\_timeout to 60sec [\#22](https://github.com/nubisproject/nubis-terraform/pull/22) ([gozer](https://github.com/gozer))
- Enable all available metrics in our autoscaling groups [\#20](https://github.com/nubisproject/nubis-terraform/pull/20) ([gozer](https://github.com/gozer))
- Shorten ELB names by removing -elb and the region, they are redundant [\#18](https://github.com/nubisproject/nubis-terraform/pull/18) ([gozer](https://github.com/gozer))
- \[worker\] Fix template error [\#16](https://github.com/nubisproject/nubis-terraform/pull/16) ([gozer](https://github.com/gozer))
- Don't use the dualstack ELB name, as it will offer ipv6 addresses which don't work [\#15](https://github.com/nubisproject/nubis-terraform/pull/15) ([gozer](https://github.com/gozer))
- Additional userdata [\#13](https://github.com/nubisproject/nubis-terraform/pull/13) ([limed](https://github.com/limed))
- Add support for ssl\_cert\_name\_prefix [\#11](https://github.com/nubisproject/nubis-terraform/pull/11) ([gozer](https://github.com/gozer))
- Enable travis-ci [\#6](https://github.com/nubisproject/nubis-terraform/pull/6) ([gozer](https://github.com/gozer))
- use tls provider to effectively generate a stable, random default password for databases [\#5](https://github.com/nubisproject/nubis-terraform/pull/5) ([gozer](https://github.com/gozer))
- \[storage\] Add support for EFS [\#3](https://github.com/nubisproject/nubis-terraform/pull/3) ([gozer](https://github.com/gozer))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*