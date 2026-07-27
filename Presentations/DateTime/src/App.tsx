import { useEffect, useState } from 'react'
import { slides } from './slides'

type Theme = 'dark' | 'light'
const playgroundHref =
  'file:///Users/a.asadi/Developer/DateTime/DateAndTime.playground'

function App() {
  const [index, setIndex] = useState(0)
  const [theme, setTheme] = useState<Theme>('dark')
  const slide = slides[index]

  useEffect(() => {
    const media = window.matchMedia('(prefers-color-scheme: light)')
    if (media.matches) {
      setTheme('light')
    }
  }, [])

  useEffect(() => {
    document.documentElement.dataset.theme = theme
  }, [theme])

  useEffect(() => {
    const onKeyDown = (event: KeyboardEvent) => {
      if (event.key === 'ArrowRight') {
        setIndex((current) => Math.min(current + 1, slides.length - 1))
      }

      if (event.key === 'ArrowLeft') {
        setIndex((current) => Math.max(current - 1, 0))
      }
    }

    window.addEventListener('keydown', onKeyDown)
    return () => window.removeEventListener('keydown', onKeyDown)
  }, [])

  useEffect(() => {
    const onCopyClick = async (event: MouseEvent) => {
      const target = event.target
      if (!(target instanceof HTMLElement)) {
        return
      }

      const button = target.closest<HTMLButtonElement>('[data-copy]')
      if (!button) {
        return
      }

      const text = button.dataset.copy
      if (!text) {
        return
      }

      const original = button.textContent
      await navigator.clipboard.writeText(text)
      button.textContent = 'Copied'
      window.setTimeout(() => {
        button.textContent = original
      }, 1200)
    }

    window.addEventListener('click', onCopyClick)
    return () => window.removeEventListener('click', onCopyClick)
  }, [])

  return (
    <main className="app-shell">
      <header className="topbar">
        <div>
          <p className="eyebrow">Date &amp; Time in Software Engineering</p>
          <h2>{slide.section}</h2>
        </div>
        <div className="topbar-actions">
          <button
            type="button"
            className="nav-action"
            onClick={() => setIndex((current) => Math.max(current - 1, 0))}
            disabled={index === 0}
            aria-label="Previous slide"
            title="Previous slide"
          >
            <span aria-hidden="true">←</span>
            Previous
          </button>
          <button
            type="button"
            className="nav-action"
            onClick={() =>
              setIndex((current) => Math.min(current + 1, slides.length - 1))
            }
            disabled={index === slides.length - 1}
            aria-label="Next slide"
            title="Next slide"
          >
            Next
            <span aria-hidden="true">→</span>
          </button>
          <button
            type="button"
            className="icon-button"
            onClick={() =>
              setTheme((current) => (current === 'dark' ? 'light' : 'dark'))
            }
            aria-label={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
            title={theme === 'dark' ? 'Switch to light mode' : 'Switch to dark mode'}
          >
            {theme === 'dark' ? '☀' : '☾'}
          </button>
          <div className="slide-counter">
            {index + 1} / {slides.length}
          </div>
        </div>
      </header>

      <div className="progress-track" aria-hidden="true">
        <div
          className="progress-bar"
          style={{ width: `${((index + 1) / slides.length) * 100}%` }}
        />
      </div>

      <section className="slide-frame">
        <div className="slide-meta">
          <div>
            <p className="slide-section">{slide.section}</p>
            <h1>{slide.title}</h1>
            {slide.eyebrow ? <p className="slide-eyebrow">{slide.eyebrow}</p> : null}
          </div>
          {slide.liveCoding ? (
            <a
              className="badge playground-link"
              href={playgroundHref}
              title="Open DateAndTime.playground"
            >
              Live Coding <span aria-hidden="true">↗</span>
            </a>
          ) : null}
        </div>

        <div className="slide-content">{slide.render()}</div>

        {slide.references?.length ? (
          <footer className="references-panel">
            <span>References</span>
            <div className="reference-links">
              {slide.references.map((reference) => (
                <a
                  key={`${slide.id}-${reference.href}`}
                  href={reference.href}
                  target="_blank"
                  rel="noreferrer"
                >
                  {reference.label}
                </a>
              ))}
            </div>
          </footer>
        ) : null}
      </section>
    </main>
  )
}

export default App
