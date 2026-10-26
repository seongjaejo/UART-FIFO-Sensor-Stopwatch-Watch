# UART / FIFO / Sensor / Stopwatch·Watch 통합 시스템

UART 통신, FIFO 버퍼, SR04 초음파·DHT11 온습도 센서, Stopwatch/Watch 기능을 하나의 FPGA 시스템으로 통합한 3인 팀 프로젝트입니다.
버튼 입력과 UART 명령(R/L/U/D/M/S)이 같은 기능을 중복 없이 제어하도록 설계했고,
시간·거리·온습도 정보를 FND와 UART로 동시에 출력하는 UART Loopback 구조를 구현했습니다.

- **Top module**: `top_final`
- **언어 / 보드**: Verilog / Basys3 (Artix-7), Vivado
- **진행**: 경기도팹리스아카데미 온디바이스AI 시스템반도체 설계 2기 (2026.05)

## 본인 담당

- SR04 초음파 센서 Controller FSM 설계 (Trig 생성, Echo 펄스 폭 측정 → 거리 환산)
- UART·Sensor 관련 ASM/FSM 설계 (모드별 상태 데이터를 ASCII 문자열로 변환해 TX FIFO로 송신)

## 설계 사양

| 항목 | 내용 |
|---|---|
| 동작 클럭 | 100 MHz |
| UART | 9600 bps, 16x Oversampling, 8N1 |
| FIFO | RX FIFO(UART 수신), TX FIFO(ASCII 송신) |
| 입력 | Push Button, Switch, UART 명령(R/L/U/D/M/S) |
| 출력 | 4-digit FND, LED, UART ASCII 상태 출력 |

## 검증 실행

Icarus Verilog 13과 Python이 필요합니다. 저장소 루트에서 실행합니다.

```sh
python verification/run_checks.py
```

시뮬레이션 시간을 줄이기 위해 UART 테스트는 baud 분주값을 단축해 실행합니다.
실행한 테스트와 로그는 `verification/`에 있으며, 테스트 범위와 알려진 제한은 [검증 기록](SELECTION_AND_VALIDATION.md)에 정리했습니다.
이 저장소의 검증은 시뮬레이션 기준이며, 실물 보드 재시험·합성·타이밍 검증 완료를 의미하지 않습니다.
