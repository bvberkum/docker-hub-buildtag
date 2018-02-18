
define pre_commit
$$package_scripts_pre_commit__0
endef

export pre_commit


define FIG1_DIGRAPH
digraph {
  rankdir="LR" ;
  node [ shape=Mrecord ] ;

  GIT [ label="GIT", URL="$$package_urls_source_code__0" ] ;
  Travis [ label="Travis", URL="$$package_urls_builds__0" ] ;
  Docker_Hub [ label="Docker Hub", URL="$$package_urls_images__0" ] ;

  GIT -> Travis [ label="build" ] ;
  Travis -> Docker_Hub [ label="images" ] ;
  Travis -> GIT [ label="releases" ] ;

  labelloc="t";
  label="Build app with centurylink/golang-builder-cross" ;

  // vim:ft=dot:
}
endef

export FIG1_DIGRAPH


define ReadMe_md
# [![](http://img.shields.io/travis/bvberkum/$$package_main.svg)](https://travis-ci.org/bvberkum/$$package_main) ![repo license](https://img.shields.io/github/license/bvberkum/$$package_main.svg) ![commits per year](https://img.shields.io/github/commit-activity/y/bvberkum/$$package_main.svg) ![](https://img.shields.io/github/languages/code-size/bvberkum/$$package_main.svg) ![](https://img.shields.io/github/repo-size/bvberkum/$$package_main.svg)
###### master: ![latest/master](https://img.shields.io/github/last-commit/bvberkum/$$package_main/master.svg) latest: ![image size](https://img.shields.io/imagelayers/image-size/bvberkum/$$package_bin/latest.svg) ![image layers](https://img.shields.io/imagelayers/layers/bvberkum/$$package_bin/latest.svg) release: ![](https://img.shields.io/github/tag/bvberkum/$$package_main.svg)
###### dev: ![dev](https://img.shields.io/github/last-commit/bvberkum/$$package_main/dev.svg) ![image size](https://img.shields.io/imagelayers/image-size/bvberkum/$$package_bin/dev.svg) ![image
layers](https://img.shields.io/imagelayers/layers/bvberkum/$$package_bin/dev.svg)

##### Version: $$package_version

$$(cat ReadMe.txt)

<img src="assets/ReadMe-fig1.svg" alt="Fig 1. illustration of main project flow. " width="40%" >

### Usage
\`\`\`bash
$$package_scripts_hubmon_help__0
\`\`\`

\`\`\`bash
docker run -d --name redis redis
docker run --link redis:db -p 8123:80 bvberkum/hubmon -redis db:6379 -cache-timeout 10
\`\`\`

\`\`\`markdown
[![alt text](http://localhost:8123/badge/bvberkum/hubmon)](https://hub.docker.com/r/bvberkum/hubmon)
\`\`\`

### Test
\`\`\`bash
$$package_scripts_test__0
\`\`\`

#### Travis
\`\`\`bash
$$package_scripts_travis_init__0
$$package_scripts_travis_init__1
$$package_scripts_travis_init__2
\`\`\`
endef

export ReadMe_md
