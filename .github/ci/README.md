# Integration performance

Each OS job runs its suites on one GitHub-hosted runner. Workstation, Kitchen,
kitchen-dokken and downloaded base images are shared within that job. Each suite
still runs `kitchen test --destroy=always` with two converges and a fresh container.

The prepare job selects one Workstation version and exact cookbook Git revisions,
then restores or populates the cookbook download cache before the matrix starts.
Every matrix job regenerates its Policyfile lock for its own checkout. Neither
Kitchen state nor converged containers are cached.

Grouped jobs have a 30-minute deadline to prevent a stalled suite holding a
runner for hours.

CI sets `KITCHEN_REUSE_IMAGES=true`: Dokken pulls an image when it is missing,
then uses that local image for later suites. Local runs keep Dokken's usual
pull-on-each-create behaviour unless explicitly given that variable. Standard
GitHub-hosted VMs are fresh for each job; this does not retain a VM across runs.

## Docker image delivery benchmark

[Run on 20 October 2026](https://github.com/sous-chefs/apache2/actions/runs/39509952839)
compared three fresh runners per method and OS. Every pair included the Cinc
image and the OS image. Both methods used identical digests and checked image IDs.

| OS | Pull median (range) | Restore and load median (range) |
| --- | ---: | ---: |
| AlmaLinux 9 | 11.05s (10.69–12.01s) | 13.84s (13.31–19.72s) |
| openSUSE Leap 15 | 15.96s (14.97–20.03s) | 19.89s (18.87–20.61s) |
| Ubuntu 24.04 | 14.35s (13.56–17.61s) | 21.11s (15.77–24.54s) |

Restore timing includes Actions cache download, decompression and `docker load`.
Pull timing includes fetching the digest and tagging it for Dokken. Both exclude
checkout, manifest download, runner setup and queue time. Cache creation is an
additional cost reported in the seed jobs. Direct pulls won all three medians,
so normal integration jobs do not restore Docker image archives.

The separate image benchmark only runs on manual dispatch or changes to its own
workflow/script. Its artifacts retain the individual measurements for seven days.
The results above describe these images and runners; they are not a universal
claim that image caching is slower.

## Suite grouping comparison

The [initial comparison](https://github.com/sous-chefs/apache2/actions/runs/39509953258)
used the same commit, cookbook revisions, runner type and eight-job limit for
both layouts. Nine complete matched OS groups covered 78 suites:

| Layout | Active job time |
| --- | ---: |
| Individual suite jobs | 7,359s (122.7 minutes) |
| Suites grouped by OS | 4,931s (82.2 minutes) |

Grouping used 33.0% fewer active runner minutes for that subset. This excludes
queue time and does not measure end-to-end completion time. The complete matrix
comparison did not finish: two individual AlmaLinux jobs were still in Dokken
after almost 30 minutes. At the recorded snapshot, 15 grouped OS jobs and 99
individual jobs had passed. Unfinished OS comparisons are excluded from the
figures above, so the result must not be presented as a full-matrix saving.

The temporary individual baseline jobs have been removed. The normal grouped
workflow retains all 148 original suite/platform combinations. The additional
image-reuse and cache-priming changes were applied after this comparison; their
benefit is not included in the measured saving.
