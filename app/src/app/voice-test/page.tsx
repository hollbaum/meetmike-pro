'use client';

import { useState, useRef, useCallback } from 'react';

const WS_URL = 'ws://136.243.148.151:18000/ws';

export default function VoiceTestPage() {
  const [status, setStatus] = useState('Disconnected');
  const [transcript, setTranscript] = useState('');
  const [reply, setReply] = useState('');
  const [textInput, setTextInput] = useState('');
  const [isRecording, setIsRecording] = useState(false);
  const wsRef = useRef<WebSocket | null>(null);
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const chunksRef = useRef<Blob[]>([]);

  const connect = useCallback(() => {
    if (wsRef.current?.readyState === WebSocket.OPEN) return;

    const ws = new WebSocket(WS_URL);
    wsRef.current = ws;

    ws.onopen = () => setStatus('Connected');
    ws.onclose = () => setStatus('Disconnected');
    ws.onerror = () => setStatus('Error');

    ws.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        if (data.transcript) setTranscript(data.transcript);
        if (data.reply) setReply(data.reply);
        if (data.echo) setReply(`Echo: ${data.echo}`);
      } catch {
        setReply(event.data);
      }
    };
  }, []);

  const disconnect = useCallback(() => {
    wsRef.current?.close();
    wsRef.current = null;
    setStatus('Disconnected');
  }, []);

  const startRecording = useCallback(async () => {
    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      const mediaRecorder = new MediaRecorder(stream);
      mediaRecorderRef.current = mediaRecorder;
      chunksRef.current = [];

      mediaRecorder.ondataavailable = (e) => {
        if (e.data.size > 0) chunksRef.current.push(e.data);
      };

      mediaRecorder.onstop = async () => {
        const blob = new Blob(chunksRef.current, { type: 'audio/webm' });
        const reader = new FileReader();
        reader.onloadend = () => {
          const base64 = (reader.result as string).split(',')[1];
          if (wsRef.current?.readyState === WebSocket.OPEN) {
            wsRef.current.send(JSON.stringify({ audio: base64 }));
          }
        };
        reader.readAsDataURL(blob);
        stream.getTracks().forEach(track => track.stop());
      };

      mediaRecorder.start();
      setIsRecording(true);
    } catch (err) {
      console.error('Mic error:', err);
      setStatus('Mic access denied');
    }
  }, []);

  const stopRecording = useCallback(() => {
    mediaRecorderRef.current?.stop();
    setIsRecording(false);
  }, []);

  const sendText = useCallback(() => {
    if (wsRef.current?.readyState === WebSocket.OPEN && textInput.trim()) {
      wsRef.current.send(JSON.stringify({ text: textInput }));
      setTextInput('');
    }
  }, [textInput]);

  return (
    <div style={{ padding: '2rem', maxWidth: '600px', margin: '0 auto', fontFamily: 'system-ui' }}>
      <h1 style={{ marginBottom: '1rem' }}>Voice POC Test</h1>

      <div style={{ marginBottom: '1rem' }}>
        <strong>Status:</strong>{' '}
        <span style={{ color: status === 'Connected' ? 'green' : 'red' }}>{status}</span>
      </div>

      <div style={{ display: 'flex', gap: '0.5rem', marginBottom: '1.5rem' }}>
        <button onClick={connect} disabled={status === 'Connected'}>Connect</button>
        <button onClick={disconnect} disabled={status !== 'Connected'}>Disconnect</button>
      </div>

      <div style={{ marginBottom: '1.5rem' }}>
        <h3>Voice Input</h3>
        <button
          onClick={isRecording ? stopRecording : startRecording}
          disabled={status !== 'Connected'}
          style={{
            padding: '1rem 2rem',
            backgroundColor: isRecording ? '#ff4444' : '#4CAF50',
            color: 'white',
            border: 'none',
            borderRadius: '8px',
            cursor: status === 'Connected' ? 'pointer' : 'not-allowed'
          }}
        >
          {isRecording ? 'Stop Recording' : 'Start Recording'}
        </button>
      </div>

      <div style={{ marginBottom: '1.5rem' }}>
        <h3>Text Input</h3>
        <div style={{ display: 'flex', gap: '0.5rem' }}>
          <input
            type="text"
            value={textInput}
            onChange={(e) => setTextInput(e.target.value)}
            onKeyPress={(e) => e.key === 'Enter' && sendText()}
            placeholder="Type a message..."
            style={{ flex: 1, padding: '0.5rem' }}
            disabled={status !== 'Connected'}
          />
          <button onClick={sendText} disabled={status !== 'Connected'}>Send</button>
        </div>
      </div>

      <div style={{ marginBottom: '1rem' }}>
        <h3>Transcript</h3>
        <div style={{ padding: '1rem', backgroundColor: '#f0f0f0', borderRadius: '4px', minHeight: '50px' }}>
          {transcript || '(waiting for voice input...)'}
        </div>
      </div>

      <div>
        <h3>Reply</h3>
        <div style={{ padding: '1rem', backgroundColor: '#e8f4e8', borderRadius: '4px', minHeight: '50px' }}>
          {reply || '(waiting for response...)'}
        </div>
      </div>

      <p style={{ marginTop: '2rem', fontSize: '0.8rem', color: '#666' }}>
        WebSocket: {WS_URL}
      </p>
    </div>
  );
}
