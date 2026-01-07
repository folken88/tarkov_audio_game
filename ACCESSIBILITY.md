# Accessibility Features

## Overview
The Tarkov Weapon Sound Trainer is fully accessible for blind and visually impaired users through comprehensive keyboard navigation and screen reader support.

## Keyboard Navigation

### Primary Controls

| Key | Action |
|-----|--------|
| **P** or **Space** | Play weapon sound |
| **Arrow Keys** | Navigate between weapon choices (↑↓←→) |
| **Enter** | Select currently focused weapon |
| **1-8** | Quick select weapon by number (auto-selects after 300ms) |
| **N** | Start new game |
| **S** | Skip round (-1 pt) or go to next round |
| **R** | Repeat current game status |
| **Ctrl+H** | Show keyboard shortcuts help |
| **Tab** | Standard focus navigation |

### Skip Links
- Skip to main content
- Skip to game controls  
- Skip to weapon choices

## Screen Reader Support

### Automatic Announcements

**Game Start**
- Announces available keyboard shortcuts and navigation instructions

**New Round**
- Announces round number
- Lists total number of weapon choices
- Announces the first weapon name and position
- Provides navigation instructions

**Weapon Navigation**
- As you navigate with arrow keys, each weapon name is announced
- Position information (e.g., "3 of 8") is provided
- Selection instructions are included in ARIA labels

**Selection Feedback**
- **Correct Answer**: Pleasant ascending tone + announcement with points earned, new score, and streak
- **Incorrect Answer**: Descending tone + announcement with correct answer, point deduction, and streak reset

**Score Updates**
- Score, streak, and correct/incorrect counts announced on request (R key)

### ARIA Implementation

**Live Regions**
- `role="status"` with `aria-live="polite"` for general announcements
- `role="alert"` with `aria-live="assertive"` for important feedback (correct/incorrect)
- `role="log"` for round history

**Semantic HTML**
- Proper heading hierarchy (h1, h2)
- Landmark regions (main, section, footer)
- Descriptive labels on all interactive elements
- Group labels for related controls

**Button Labels**
- All weapon buttons include: weapon name, position, and selection instruction
- Control buttons include keyboard shortcuts in their labels
- Icons have `aria-hidden="true"` to avoid confusion

## Audio Feedback

### Success Tone
- 3-note ascending chord (C5 → E5 → G5)
- Duration: 300ms
- Volume: 15% of max

### Failure Tone  
- 2-note descending sequence (G4 → D4)
- Duration: 300ms
- Volume: 15% of max

Both tones use Web Audio API oscillators and will not interfere with weapon sound playback or screen reader audio.

## Focus Management

**Auto-Focus on Round Start**
- First weapon choice receives focus automatically
- Immediate screen reader announcement of choices
- Focus position tracked for arrow key navigation

**Visual Focus Indicators**
- 3px yellow outline on focused elements
- Consistent with hover states for sighted keyboard users
- Outline offset for clear visibility

**Focus Restoration**
- Focus maintained when navigating grid with arrow keys
- Focus reset to first weapon on new round

## Accessibility Best Practices Implemented

✅ **WCAG 2.1 Level AA Compliant**
- Keyboard accessible
- Screen reader compatible
- Sufficient color contrast
- Focus visible
- Meaningful sequence
- Status messages

✅ **User Experience**
- No keyboard traps
- Logical tab order
- Clear feedback for all actions
- Consistent navigation patterns
- Non-visual success/failure indicators

✅ **Technical Implementation**
- Semantic HTML5
- ARIA landmarks and labels
- Live regions for dynamic content
- Keyboard event handling
- Audio cues using Web Audio API

## Testing Recommendations

### Screen Readers Tested
- NVDA (Windows)
- JAWS (Windows)
- VoiceOver (macOS/iOS)
- TalkBack (Android)
- Narrator (Windows)

### Testing Scenarios
1. Complete a full game using only keyboard
2. Navigate weapon choices with arrow keys
3. Verify all announcements are clear and informative
4. Ensure audio cues are distinct and not overwhelming
5. Test quick selection with number keys
6. Verify skip links function correctly

## Future Enhancements (Planned)

- [ ] Boss voice line identification mode (when audio resources available)
- [ ] Footstep sound identification mode (when audio resources available)
- [ ] Configurable audio cue preferences
- [ ] Adjustable announcement verbosity
- [ ] Custom keyboard shortcut mapping
- [ ] Practice mode with immediate feedback

## Feedback

Users experiencing accessibility issues or having suggestions for improvements should report them via the project's issue tracker.










