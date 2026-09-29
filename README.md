# Mirattic

**함께 보고, 함께 일하는 곳.** — <https://mirattic.com>

Mirattic은 친구와 영상을 같은 순간에 보는 **Mirattic Sync**와, 팀이 이슈와 대화를 한곳에서 나누는 **Mirattic Flow**를 만든다.
두 서비스는 **Mirattic 계정** 하나로 쓴다. 이 저장소는 그 입구인 mirattic.com 소개 페이지다.

## 서비스

| 서비스 | 주소 | 한 줄 소개 | 저장소 |
|---|---|---|---|
| Mirattic Sync | [sync.mirattic.com](https://sync.mirattic.com) | 친구와 같은 영상을 같은 초에 — 재생·일시정지·이동을 방 안 모두에게 맞추는 Chrome 확장 | `mirattic-sync` |
| Mirattic Flow | [flow.mirattic.com](https://flow.mirattic.com) | 워크스페이스·프로젝트·이슈 관리와 실시간 채팅·알림을 한 화면에서 | [`MiratticFlow`](https://github.com/G1Se0k/MiratticFlow) |
| Mirattic 계정 | [auth.mirattic.com](https://auth.mirattic.com) | 이메일·카카오·네이버 로그인, 기기·연동·탈퇴 관리 (OAuth 2.0 / OIDC) | `mirattic-auth` |
| 소개 페이지 | [mirattic.com](https://mirattic.com) | 이 저장소 | `mirattic-main` |

### Mirattic Sync
- 방장이 재생하면 모두 재생 — 멈추고 넘기는 것도 모두의 화면이 따라간다
- 영상은 각자 브라우저에서 재생한다. Mirattic은 재생 **메타데이터만** 동기화하고 영상·음성을 녹화하거나 중계하지 않는다
- 영상 옆 사이드 패널에서 대화. YouTube 지원, Netflix·라프텔은 실험 단계
- Chrome 확장(WXT, MV3) + Spring Boot 서버, WebSocket으로 서버 시각 기준 동기화

### Mirattic Flow
- 워크스페이스 · 프로젝트 · 이슈 — 담당자, 우선순위, 마감일, 상태를 한눈에
- 프로젝트 채팅과 이슈별 주제 채팅 — 이야기한 내용이 그 이슈에 남는다
- 알림과 대시보드 — 내 담당과 진행 상황을 놓치지 않는다
- Next.js + Spring Boot, STOMP over WebSocket

### Mirattic 계정
- 이메일, 카카오, 네이버 중 편한 방법으로 가입·로그인하고 Sync와 Flow에 같은 계정으로 들어간다
- 비밀번호는 Mirattic 계정에서만 입력한다. 각 서비스는 비밀번호를 받지도, 저장하지도 않는다
- 로그인된 기기, 최근 보안 활동, 탈퇴까지 계정 페이지에서 직접 관리한다

## 구조

```text
Browser / Chrome extension
  └─ HTTPS → host Caddy (subdomain routing, automatic TLS)
       ├─ mirattic.com   → static page (this repo)
       ├─ auth.*         → Mirattic Auth ── Auth DB
       ├─ flow.*         → Mirattic Flow ── Flow DB ─┐
       └─ sync.*         → Mirattic Sync ── Sync DB ─┴─ verify Auth tokens (JWKS)
```

- **Auth는 "누구인가"만, 각 서비스는 "무엇을 할 수 있는가"를** 맡는다. 서비스는 Auth DB에 접근하지 않고, Auth가 발급한 토큰의 `sub`(UUID)로만 사용자를 식별한다
- Sync와 Flow는 **기밀 클라이언트**다. 각 백엔드가 client secret + PKCE로 code를 교환하고, 토큰은 브라우저 스크립트에 닿지 않는다
- 계정 탈퇴는 Auth가 Flow와 Sync에 서명된 삭제 요청을 보내고, 둘 다 성공해야 계정을 지운다
- 모든 서비스는 같은 호스트에서 돌고, 각 저장소의 `main`에 push하면 GitHub Actions가 배포한다

## 이 저장소

- 빌드 없는 정적 페이지: `public/` (`index.html` + `assets/`). 이 폴더만 공개된다
- 배포: main 에 push → GitHub Actions 가 호스트에 SSH → `deploy/deploy.sh` 가 `public/` 을
  `/opt/homebrew/var/www/mirattic` 로 복사. 호스트 Caddy(`/opt/homebrew/etc/Caddyfile`)가 `mirattic.com` 으로 서빙,
  `www.mirattic.com` 은 `mirattic.com` 으로 이동. CI 키는 호스트 `authorized_keys` 에서 이 스크립트만 실행할 수 있다
- 디자인은 sync.mirattic.com 과 같은 색·글꼴·레이아웃, 라이트/다크
- 로컬 미리보기: `python3 -m http.server 8765 -d public` → http://127.0.0.1:8765

에셋 출처: `mirattic-mark.svg`·파비콘은 Mirattic Auth, `sync-*`는 Mirattic Sync 랜딩, `flow-*`는 Mirattic Flow(`frontend/public/logo-mark.png`, `docs/images/issue-detail.png`).
