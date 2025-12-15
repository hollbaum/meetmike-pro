import { HeroCanvas } from '@/components/HeroCanvas';
import { MiniChat } from '@/components/MiniChat';

const services = [
  {
    title: "Mixed Intelligence Strategy",
    desc: "Identify where Human × AI creates the biggest multiplier effect for your business.",
  },
  {
    title: "Solution Design",
    desc: "Architecture, data flows, and guardrails that keep humans in control.",
  },
  {
    title: "Workflow Automation",
    desc: "Streamline operations with smart workflows that amplify your team's capability.",
  },
  {
    title: "Custom Development",
    desc: "Build tailored applications, integrations, and APIs that fit your stack.",
  },
  {
    title: "Ethics & Governance",
    desc: "Risk assessments, policies, and monitoring to keep AI safe, fair, and compliant.",
  },
  {
    title: "Training & Enablement",
    desc: "Upskill your team to work effectively with AI—playbooks, workshops, and best practices.",
  },
];

export default function Home() {
  return (
    <>
      {/* Hero Canvas - NEW */}
      <HeroCanvas />
      
      {/* Mini Chat - NEW */}
      <MiniChat />

      {/* Rest of existing content */}
      <div className="min-h-screen bg-gradient-to-br from-slate-900 via-slate-950 to-black text-slate-50">
        <div className="relative mx-auto flex min-h-screen max-w-6xl flex-col gap-20 px-6 py-16 sm:px-10 lg:px-14">
          <div className="pointer-events-none absolute inset-0 -z-10 opacity-50 blur-3xl" aria-hidden>
            <div className="absolute left-10 top-10 h-64 w-64 rounded-full bg-purple-500/20" />
            <div className="absolute right-10 bottom-20 h-72 w-72 rounded-full bg-cyan-400/20" />
          </div>

          {/* Hero */}
          <header className="flex flex-col gap-8 lg:flex-row lg:items-center lg:justify-between">
            <div className="space-y-6 lg:max-w-2xl">
              <p className="text-sm uppercase tracking-[0.3em] text-purple-200/80">Meet Mike · Mixed Intelligence</p>
              <h1 className="text-4xl font-semibold leading-tight text-white sm:text-5xl lg:text-6xl">
                Human × AI: Multiply Your Impact
              </h1>
              <p className="text-lg leading-relaxed text-slate-200/80 sm:text-xl">
                Mixed Intelligence combines human expertise with AI capability to deliver outcomes neither can achieve alone.
                We design, build, and deploy solutions that amplify your team—not replace them.
              </p>
              <div className="flex flex-wrap gap-3">
                <a
                  href="mailto:contact@meetmike.pro"
                  className="rounded-full bg-purple-500 px-6 py-3 text-sm font-semibold text-white shadow-lg shadow-purple-500/30 transition hover:-translate-y-0.5 hover:bg-purple-400"
                >
                  Book a Consultation
                </a>
                <a
                  href="#services"
                  className="rounded-full border border-white/20 px-6 py-3 text-sm font-semibold text-white/90 transition hover:-translate-y-0.5 hover:border-white/40"
                >
                  Explore Services
                </a>
              </div>
            </div>
            <div className="rounded-2xl border border-white/10 bg-white/5 p-6 shadow-2xl shadow-purple-500/10 backdrop-blur lg:max-w-sm">
              <h3 className="text-lg font-semibold text-white">Why teams pick Meet Mike</h3>
              <ul className="mt-4 space-y-3 text-sm text-slate-200/80">
                <li>• Human × AI: amplify your team, don&apos;t replace them</li>
                <li>• End-to-end delivery: strategy → design → build → launch</li>
                <li>• Production guardrails with humans in control</li>
              </ul>
            </div>
          </header>

          {/* Services */}
          <section id="services" className="space-y-8">
            <div>
              <p className="text-sm uppercase tracking-[0.3em] text-purple-200/80">Services</p>
              <h2 className="mt-3 text-3xl font-semibold text-white sm:text-4xl">From idea to production</h2>
              <p className="mt-3 max-w-3xl text-base text-slate-200/80">
                We help you find where Human × AI creates the biggest impact, architect robust solutions, and deliver them into production with humans in control.
              </p>
            </div>
            <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {services.map((service) => (
                <div
                  key={service.title}
                  className="rounded-2xl border border-white/10 bg-white/5 p-6 shadow-lg shadow-purple-500/5 transition hover:-translate-y-1 hover:border-purple-300/40 hover:bg-white/10"
                >
                  <h3 className="text-lg font-semibold text-white">{service.title}</h3>
                  <p className="mt-3 text-sm leading-relaxed text-slate-200/80">{service.desc}</p>
                </div>
              ))}
            </div>
          </section>

          {/* About */}
          <section className="grid gap-8 lg:grid-cols-[1.1fr_0.9fr]">
            <div className="space-y-4">
              <p className="text-sm uppercase tracking-[0.3em] text-purple-200/80">About</p>
              <h2 className="text-3xl font-semibold text-white sm:text-4xl">Meet Mike · Mixed Intelligence</h2>
              <p className="text-base leading-relaxed text-slate-200/80">
                Mixed Intelligence is Human Intelligence × AI—the multiplier effect that transforms how teams work.
                We deliver production-grade solutions across strategy, automation, and custom development,
                focusing on outcomes that amplify human capability: better decisions, faster execution, and sustainable growth.
              </p>
              <p className="text-base leading-relaxed text-slate-200/80">
                One team that thinks, builds, and ships alongside you—human expertise and AI capability working as one.
              </p>
            </div>
            <div className="rounded-2xl border border-white/10 bg-white/5 p-6 shadow-lg shadow-cyan-400/10">
              <h3 className="text-lg font-semibold text-white">Engagement snapshot</h3>
              <ul className="mt-4 space-y-3 text-sm text-slate-200/80">
                <li>• Discovery: goals, data, risks, and quick wins</li>
                <li>• Design: architecture, human-in-the-loop, metrics, governance</li>
                <li>• Build & Ship: iterative delivery with observability and QA</li>
                <li>• Operate: monitoring, model updates, ongoing optimization</li>
              </ul>
            </div>
          </section>

          {/* CTA */}
          <section className="rounded-3xl border border-white/10 bg-gradient-to-r from-purple-500/30 to-cyan-500/30 p-8 shadow-xl shadow-purple-500/20">
            <div className="flex flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
              <div>
                <p className="text-sm uppercase tracking-[0.3em] text-white/80">Let&apos;s talk</p>
                <h3 className="text-2xl font-semibold text-white sm:text-3xl">Ready to multiply your team&apos;s impact?</h3>
                <p className="mt-2 text-base text-white/80">contact@meetmike.pro · Response within 1 business day</p>
              </div>
              <a
                href="mailto:contact@meetmike.pro"
                className="inline-flex items-center justify-center rounded-full bg-white px-6 py-3 text-sm font-semibold text-slate-900 shadow-lg shadow-white/30 transition hover:-translate-y-0.5"
              >
                Schedule a call
              </a>
            </div>
          </section>
        </div>
      </div>
    </>
  );
}
