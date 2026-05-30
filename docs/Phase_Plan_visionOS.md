# Part B — Option 02 — visionOS App Plan (NurseryConnect)

**Course:** SE4020 — Mobile Application Design and Development (Semester 1, 2026)
**Student:** IT22346322 — MJM ARSHAQ
**Weight:** 15% (100 marks rubric)
**Deadline:** 3 June 2026 · **Viva:** 6–7 June 2026
**Goal:** A spatial-computing prototype for Apple Vision Pro that extends the Part A NurseryConnect (Keyworker) work using genuine spatial UX — not flat UI in 3D.

> **Selected** as Part B (15-mark ceiling, instead of watchOS). The brief warns this needs extra time on curated tutorials/labs — budget for the Learning Reflection (15 marks).

---

## 0. LOCKED DECISIONS

| Decision | **Locked choice** | Why |
|---|---|---|
| Concept | **NurseryConnect Spatial Day Dashboard** — a flat **Window** showing the Keyworker's child roster, beside a bounded **Volume** holding a simple 3D model of the nursery room with a tappable peg/locker per child. Tapping a child opens a SwiftUI panel attached in 3D space showing that child's day (diary summary + wellbeing + an incident flag). | Anchors directly to the Part A Keyworker role and reuses the same conceptual data (`Child` / `DiaryEntry` / `IncidentReport`). Gives real spatial value (glance the room, not a list) without needing a full 360° environment. |
| Scene type | **Window + bounded Volume** (primary). **Immersive Space = stretch goal only** (a small "calm corner"). | Window + Volume is achievable in the time; full immersion is high-risk for a 4-day build. |
| Data | Re-use the A1 model types with a **seeded in-memory store** (no CloudKit). | Keeps the prototype self-contained and demo-ready. |
| UI tech | SwiftUI panels + RealityKit content + Reality Composer Pro scene + `RealityView` / `attachment(id:)`. | Required mix for genuine spatial UX. |
| Tooling | Xcode 15+ (16 recommended) with visionOS SDK, **visionOS simulator** (no Vision Pro device needed). | |
| Input model | Eye + pinch (default) + `SpatialTapGesture` on entities; hand tracking = stretch. | |

> **Rule from brief:** No login / auth / access control — launch directly into the experience.

> **Three required spatial interactions to guarantee marks:** (1) tap a child's peg in the Volume → attached panel slides out; (2) walk around / rotate the room Volume; (3) a spatial-audio confirmation chime on tap. Build these before any polish.

---

## Phase 1 — Curated Learning (Required by Brief)  *(~4 hrs, Day 1 morning)*

**Objective:** Hit Learning Reflection (15 marks) — *minimum 3 curated resources referenced*. Doing this first also de-risks every later phase.

**Curated resources to draw from**
- WWDC23 — *Get started with building apps for spatial computing*.
- WWDC23 — *Meet SwiftUI for spatial computing*.
- WWDC23 — *Build spatial experiences with RealityKit*.
- WWDC23 — *Develop your first immersive app*.
- WWDC24 — *What's new in visionOS*, *Compose interactive 3D content in Reality Composer Pro*.
- Apple Developer "Hello World" sample for visionOS.
- *Develop in Swift* tutorials — spatial modules.
- Apple Labs / Vision Pro Developer Lab session notes (if attended).

**Activities**
- Watch / read at least 3 resources end-to-end.
- For each, note: what concept, what I will apply, what I will *not* use and why.
- Start the Learning Reflection draft — keep adding to it as you build.

**Deliverables**
- `docs/learning-reflection.md` draft (will grow through the project).
- `docs/resources.md` — full citations of the resources.

---

## Phase 2 — Concept Lock + Spatial UX Design  *(~3 hrs, Day 1 afternoon)*

**Objective:** Hit Creativity & Spatial UX (20 marks). The rubric explicitly rewards "innovative use of space" and penalises flat UI recreated in 3D.

**Activities**
- Refine the chosen concept; write the storyboard: *user enters the experience, sees X, interacts with Y, leaves having learned/done Z.*
- Decide each surface's spatial purpose:
  - **Window** — anchored UI, lists, controls.
  - **Volume** — a tangible 3D object the user can walk around (the nursery room model, the meal plate, the play station).
  - **Immersive Space** *(optional)* — only if a concept truly needs it (e.g., 360° nursery tour).
- Map interactions: gaze + pinch on entities, drag in space, depth-anchored panels, ornaments, attachment views.
- Decide spatial audio cues (ambient nursery sounds, confirmation chimes).
- Sketch each surface in 3D — front view + plan view.

**Deliverables**
- `docs/spatial-storyboard.md` with surface plan + interaction list + audio plan.

---

## Phase 3 — AI-Assisted Design & Prompt Logging  *(~2 hrs, Day 1 evening)*

**Objective:** Hit AI Usage Documentation (10 marks).

**Activities**
- Use at least one AI tool for: panel layout mockups, asset concepting (e.g., Midjourney for nursery-room references → later remade as actual USDZ), SwiftUI/RealityKit scaffolding (Claude / ChatGPT / Copilot).
- Generate 2–3 panel/scene mockup variations.
- Save every prompt + response verbatim with tool justification.

**Deliverables**
- `docs/ai-usage-log.md` — code-gen + design prompts and responses.
- Mockup images committed.

---

## Phase 4 — Project Setup & Spatial Skeleton  *(~3 hrs, Day 2 morning)*

**Objective:** Compiling visionOS project with the right scene structure.

**Activities**
- New Xcode project — *visionOS App*. Initial Scene type: *Window* + add a *Volume* (or *ImmersiveSpace*).
- Min visionOS 1.2.
- Folder layout: `App/`, `Views/`, `RealityKit/`, `RealityComposerPro/` (link the Reality Composer Pro package), `Models/`, `ViewModels/`, `Resources/`.
- Add a Reality Composer Pro package — create the primary scene file.
- Initial commit + GitHub push.

**Deliverables**
- Project builds; you can switch between Window and Volume from a button.

---

## Phase 5 — 3D Assets & Reality Composer Pro Scene  *(~5 hrs, Day 2 afternoon + evening)*

**Objective:** Have the spatial content the prototype hangs on.

**Activities**
- Source or build the core 3D assets (USDZ). Options:
  - Apple's Object Capture samples or sample assets.
  - Free CC-licensed USDZ models (e.g., a nursery room, plates, toys, furniture).
  - Simple primitives + materials authored in Reality Composer Pro.
- Build the scene in Reality Composer Pro — place entities, set materials, add Spatial Audio sources, set component attachments for tap targets.
- Add `InputTargetComponent` + `CollisionComponent` on every entity that must respond to taps.

**Deliverables**
- A `.realityplatform` scene committed to the package.
- All planned entities present with names you can resolve from code.

---

## Phase 6 — Core Spatial Interactivity (Prototype Functionality — 25 marks)  *(~6 hrs, Day 3)*

**Objective:** Make it *do* something real.

**Activities**
- Load the Reality Composer Pro scene into a `RealityView`.
- Attach SwiftUI `attachment(id:)` panels to entities (labels, info cards anchored in 3D space).
- Wire `SpatialTapGesture` and `DragGesture(targetedToAnyEntity)` to entity interactions:
  - Tap a child's named locker → panel slides out with their daily summary.
  - Drag plates onto a meal-tray volume → menu updates.
  - Walk around the volume → nursery-room model rotates / signs update.
- If you opted for an Immersive Space: handle `openImmersiveSpace` / `dismissImmersiveSpace` transitions and progressive immersion via `ImmersionStyle`.
- Add spatial audio cue on key interactions.
- Add at least one ornament (e.g., toolbar floating beside the main window).
- Persist any state changes per session.

**Deliverables**
- Working prototype with at least 3 distinct spatial interactions.

---

## Phase 7 — Polish, Performance, Accessibility  *(~3 hrs, Day 4 morning)*

**Activities**
- Lighting / IBL tuned in Reality Composer Pro so the scene reads cleanly in both Standard and Dim appearance.
- Reduce poly count on heavy assets if FPS drops on the simulator.
- Add `accessibilityLabel` and hover effects on every interactive entity.
- Honour Reduce Motion / Reduce Transparency.
- Confirm the experience works in seated mode and from different head positions.

**Deliverables**
- A polished, performant build.

---

## Phase 8 — Testing  *(~1.5 hrs, Day 4 midday)*

**Activities**
- Manual test pass on the visionOS simulator — every gesture, every transition, every entity.
- Test Window-only mode (user dismisses immersion).
- Edge cases: rapid taps, dragging entities out of bounds, opening/closing immersive space multiple times.
- ViewModel unit tests for data-driving logic.
- Manual checklist in `docs/vision-test-log.md`.

**Deliverables**
- Test log + screenshots.

---

## Phase 9 — Slide Deck, Demo Video, Reflection, Submission  *(~4 hrs, Day 4 afternoon)*

**Slide deck (6–8 slides, 10 marks)** — outline:
1. Title + role + 1-sentence concept.
2. Target audience + problem in the NurseryConnect context.
3. Why spatial computing (value vs flat app).
4. UX flow — storyboard.
5. Key spatial interactions (with screenshots).
6. Tech stack — SwiftUI + RealityKit + Reality Composer Pro + (extras).
7. Demo screenshot grid / GIFs.
8. Future work + reflection.

**Demo video (1–2 min, 10 marks)**
- Record from the visionOS simulator in mixed reality preview.
- Show: launching, the volume, key interactions, immersive transition (if any), ornaments, panel attachments.
- Narrate over it.

**Learning Reflection (1–2 pages, 15 marks)**
- Finalise from Phase 1.
- For each cited resource: what it taught, how it changed an implementation choice.
- Include at least 3 references.

**AI Usage Documentation (10 marks)**
- Finalise the prompt-response log from Phases 2–6.

**Submission**
- Push final commit; tag `submission`.
- Bundle: GitHub repo link, slides, video, reflection, AI log, test log.
- Submit per LMS instructions.

---

## Viva Preparation (10 marks)  *(6–7 June 2026)*

You must be able to explain:
- Why spatial computing is *the right answer* for this user — not just possible.
- Every spatial interaction's design rationale.
- The full code path for at least one gesture from entity → ViewModel → state → visible response.
- Every AI prompt — accepted, rewritten, rejected.
- What you'd do with more time, and what you'd cut.

---

## Risk Register

| Risk | Mitigation |
|---|---|
| visionOS simulator is heavy / slow on your Mac | Build with smaller scenes during dev; load big assets only when wiring final demo. Use Reality Composer Pro previews to iterate without simulator launches. |
| RealityKit + SwiftUI bridging (`RealityView` + `attachment`) is unfamiliar | Build a minimal proof from the Apple "Hello World" sample on Day 1 before committing to scope. |
| Concept slides into flat UI in 3D | Force at least one *Volume* with walkable content and one panel anchored to an entity in 3D space — both before you polish anything. |
| 3D assets eat all the time | Prefer simple primitives + materials in Reality Composer Pro over sourcing USDZ; reserve realistic assets for one hero element. |
| Immersive Space transitions break demo | Default to Window + Volume only; treat Immersive Space as a stretch goal you can cut. |
| 4-day timeline vs new framework | Trim Phase 7 polish and Phase 5 asset variety first if behind — never trim Learning Reflection (15 marks) or Slides (10 marks). |

---

## Rubric → Phase Traceability

| Rubric criterion (marks) | Covered by phase |
|---|---|
| Prototype Functionality (25) | 4, 5, 6, 7, 8 |
| Creativity & Spatial UX (20) | 2, 6, 7 |
| Presentation Pitch — Slides (10) | 9 |
| Demo (10) | 9 |
| Learning Reflection (15) | 1, 9 (kept alive throughout) |
| AI Usage Documentation (10) | 3, 9 |
| Viva Performance (10) | All — viva prep |

---

## Timeline at a glance (4 working days)

| Day | Block | Output |
|---|---|---|
| Day 1 | Phases 1–3 | Tutorials watched, concept locked, AI mockups + log started |
| Day 2 | Phases 4–5 | Project skeleton + Reality Composer Pro scene with assets |
| Day 3 | Phase 6 | Core spatial interactions implemented |
| Day 4 | Phases 7–9 | Polish, testing, slides, video, reflection, submit |

---

## Stretch Goals (only if Day 3 finishes early)

- Hand tracking with `ARKitSession` + `HandTrackingProvider` for direct-touch interactions on near entities.
- Persistence via SwiftData so the spatial state survives relaunch.
- Multi-user "FaceTime spatial" awareness (`SharePlay` / `GroupActivities`) — high cost, rarely worth it under deadline.
- AR scene reconstruction (`SceneReconstructionProvider`) for placing virtual nursery objects on real surfaces — only meaningful for the parent-tour concept.
