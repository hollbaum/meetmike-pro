'use client';

import { useRef, useEffect, useState } from 'react';
import { Typewriter } from './Typewriter';

export function HeroCanvas() {
  const inputRef = useRef<HTMLInputElement>(null);
  const [typewriterComplete, setTypewriterComplete] = useState(false);
  const [userMessage, setUserMessage] = useState('');
  const [mikeResponse, setMikeResponse] = useState('');

  useEffect(() => {
    if (typewriterComplete && inputRef.current) {
      inputRef.current.focus();
    }
  }, [typewriterComplete]);

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (userMessage.trim()) {
      // Static response for demo (Phase 2: real Claude integration)
      setMikeResponse(`That sounds interesting! I'd love to learn more about your project and explore how we can help. Want to schedule a quick call to discuss?`);
      setUserMessage('');
      setTimeout(() => {
        inputRef.current?.focus();
      }, 1000);
    }
  };

  return (
    <div className="relative min-h-screen w-full bg-white flex flex-col items-center justify-center px-4 sm:px-6 lg:px-8">
      {/* Typewriter intro */}
      <div className="w-full max-w-2xl text-center mb-8 h-32 flex flex-col justify-center">
        <div className="space-y-4">
          <Typewriter
            text="Hi. I'm Mike."
            speed={100}
            className="text-4xl sm:text-5xl lg:text-6xl font-bold text-slate-900"
          />
          <Typewriter
            text="I help teams build ambitious projects."
            speed={70}
            onComplete={() => setTypewriterComplete(true)}
            className="text-lg sm:text-xl text-slate-600 block mt-4"
          />
        </div>
      </div>

      {/* Input section */}
      {typewriterComplete && (
        <div className="w-full max-w-2xl animate-fade-in">
          <div className="mb-4 text-center">
            <p className="text-slate-600 text-lg mb-6">What's yours?</p>
          </div>

          {/* Mike's response */}
          {mikeResponse && (
            <div className="mb-6 p-4 bg-purple-50 rounded-lg border border-purple-200">
              <p className="text-slate-900">
                <span className="font-semibold text-purple-600">Mike: </span>
                {mikeResponse}
              </p>
            </div>
          )}

          {/* Input form */}
          <form onSubmit={handleSubmit} className="flex gap-2">
            <input
              ref={inputRef}
              type="text"
              value={userMessage}
              onChange={(e) => setUserMessage(e.target.value)}
              placeholder="Tell me about your project..."
              className="flex-1 px-4 py-3 bg-white border-2 border-slate-300 rounded-lg text-slate-900 placeholder-slate-500 focus:outline-none focus:border-purple-500 focus:ring-2 focus:ring-purple-200 transition"
            />
            <button
              type="submit"
              disabled={!userMessage.trim()}
              className="px-6 py-3 bg-purple-500 text-white font-medium rounded-lg hover:bg-purple-600 disabled:bg-slate-300 disabled:cursor-not-allowed transition"
            >
              Send
            </button>
          </form>
        </div>
      )}

      {/* Content peek - show site below */}
      <div className="mt-16 w-full h-32 flex items-end justify-center text-slate-400 text-sm">
        <p>↓ Scroll to explore more</p>
      </div>

      {/* CSS animation */}
      <style jsx>{`
        @keyframes fadeIn {
          from {
            opacity: 0;
            transform: translateY(10px);
          }
          to {
            opacity: 1;
            transform: translateY(0);
          }
        }

        .animate-fade-in {
          animation: fadeIn 0.5s ease-out;
        }
      `}</style>
    </div>
  );
}
