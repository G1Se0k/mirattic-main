# Mirattic

mirattic.com — Mirattic 소개 페이지. Mirattic Sync(sync.mirattic.com)와 Mirattic Flow(flow.mirattic.com)로 안내한다.

- 빌드 없는 정적 페이지: `public/` (`index.html` + `assets/`). 이 폴더만 공개된다
- 배포: main 에 push → GitHub Actions 가 호스트에 SSH → `deploy/deploy.sh` 가 `public/` 을
  `/opt/homebrew/var/www/mirattic` 로 복사. 호스트 Caddy(`/opt/homebrew/etc/Caddyfile`)가 `mirattic.com` 으로 서빙,
  `www.mirattic.com` 은 `mirattic.com` 으로 이동. CI 키는 호스트 `authorized_keys` 에서 이 스크립트만 실행할 수 있다
- 디자인은 sync.mirattic.com 과 같은 색·글꼴·레이아웃, 라이트/다크
- 로컬 미리보기: `python3 -m http.server 8765 -d public` → http://127.0.0.1:8765

에셋 출처: `mirattic-mark.svg`·파비콘은 Mirattic Auth, `sync-*`는 Mirattic Sync 랜딩, `flow-*`는 Mirattic Flow(`frontend/public/logo-mark.png`, `docs/images/issue-detail.png`).
