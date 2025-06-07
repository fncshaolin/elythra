#!/usr/bin/env python3
"""
Elythra Music - Log Analysis Tool
Analyzes testing session logs to identify patterns, issues, and performance metrics
"""

import re
import sys
import json
from datetime import datetime
from collections import defaultdict, Counter
from pathlib import Path

class LogAnalyzer:
    def __init__(self, log_file):
        self.log_file = Path(log_file)
        self.logs = []
        self.user_actions = []
        self.performance_metrics = []
        self.errors = []
        self.network_requests = []
        self.audio_events = []
        self.ui_events = []
        
    def parse_logs(self):
        """Parse the log file and categorize entries"""
        if not self.log_file.exists():
            print(f"❌ Log file not found: {self.log_file}")
            return False
            
        with open(self.log_file, 'r', encoding='utf-8', errors='ignore') as f:
            for line_num, line in enumerate(f, 1):
                line = line.strip()
                if not line:
                    continue
                    
                # Parse different log types
                if 'UserAction' in line:
                    self.parse_user_action(line, line_num)
                elif 'Performance' in line:
                    self.parse_performance(line, line_num)
                elif 'Network' in line:
                    self.parse_network(line, line_num)
                elif 'Audio' in line:
                    self.parse_audio(line, line_num)
                elif 'UI' in line:
                    self.parse_ui(line, line_num)
                elif any(error_keyword in line.lower() for error_keyword in ['error', 'exception', 'crash', 'fatal']):
                    self.parse_error(line, line_num)
                    
                self.logs.append({
                    'line_num': line_num,
                    'content': line,
                    'timestamp': self.extract_timestamp(line)
                })
        
        return True
    
    def extract_timestamp(self, line):
        """Extract timestamp from log line"""
        timestamp_pattern = r'\[(\d{2}:\d{2}:\d{2}\.\d{3})\]'
        match = re.search(timestamp_pattern, line)
        return match.group(1) if match else None
    
    def parse_user_action(self, line, line_num):
        """Parse user action logs"""
        # Pattern: [timestamp] Screen: Action -> Target | metadata
        pattern = r'\[([^\]]+)\]\s+([^:]+):\s+([^|]+?)(?:\s*\|\s*(.+))?$'
        match = re.search(pattern, line)
        if match:
            timestamp, screen, action, metadata = match.groups()
            self.user_actions.append({
                'line_num': line_num,
                'timestamp': timestamp,
                'screen': screen.strip(),
                'action': action.strip(),
                'metadata': metadata.strip() if metadata else None
            })
    
    def parse_performance(self, line, line_num):
        """Parse performance logs"""
        # Pattern: [timestamp] Operation: duration [STATUS] | metadata
        pattern = r'\[([^\]]+)\]\s+([^:]+):\s+(\d+)ms\s+\[([^\]]+)\](?:\s*\|\s*(.+))?'
        match = re.search(pattern, line)
        if match:
            timestamp, operation, duration, status, metadata = match.groups()
            self.performance_metrics.append({
                'line_num': line_num,
                'timestamp': timestamp,
                'operation': operation.strip(),
                'duration': int(duration),
                'status': status.strip(),
                'metadata': metadata.strip() if metadata else None
            })
    
    def parse_network(self, line, line_num):
        """Parse network request logs"""
        self.network_requests.append({
            'line_num': line_num,
            'content': line,
            'timestamp': self.extract_timestamp(line)
        })
    
    def parse_audio(self, line, line_num):
        """Parse audio event logs"""
        self.audio_events.append({
            'line_num': line_num,
            'content': line,
            'timestamp': self.extract_timestamp(line)
        })
    
    def parse_ui(self, line, line_num):
        """Parse UI event logs"""
        self.ui_events.append({
            'line_num': line_num,
            'content': line,
            'timestamp': self.extract_timestamp(line)
        })
    
    def parse_error(self, line, line_num):
        """Parse error logs"""
        self.errors.append({
            'line_num': line_num,
            'content': line,
            'timestamp': self.extract_timestamp(line)
        })
    
    def analyze_user_behavior(self):
        """Analyze user behavior patterns"""
        if not self.user_actions:
            return {}
            
        screen_usage = Counter(action['screen'] for action in self.user_actions)
        action_types = Counter(action['action'] for action in self.user_actions)
        
        # Calculate session duration
        timestamps = [action['timestamp'] for action in self.user_actions if action['timestamp']]
        session_duration = None
        if len(timestamps) >= 2:
            start_time = datetime.strptime(timestamps[0], '%H:%M:%S.%f')
            end_time = datetime.strptime(timestamps[-1], '%H:%M:%S.%f')
            session_duration = (end_time - start_time).total_seconds()
        
        return {
            'total_actions': len(self.user_actions),
            'session_duration_seconds': session_duration,
            'most_used_screens': screen_usage.most_common(5),
            'most_common_actions': action_types.most_common(10),
            'unique_screens': len(screen_usage),
            'actions_per_minute': len(self.user_actions) / (session_duration / 60) if session_duration else 0
        }
    
    def analyze_performance(self):
        """Analyze performance metrics"""
        if not self.performance_metrics:
            return {}
            
        durations = [metric['duration'] for metric in self.performance_metrics]
        operations = Counter(metric['operation'] for metric in self.performance_metrics)
        failed_operations = [metric for metric in self.performance_metrics if metric['status'] != 'SUCCESS']
        
        return {
            'total_operations': len(self.performance_metrics),
            'average_duration_ms': sum(durations) / len(durations),
            'max_duration_ms': max(durations),
            'min_duration_ms': min(durations),
            'failed_operations': len(failed_operations),
            'success_rate': (len(self.performance_metrics) - len(failed_operations)) / len(self.performance_metrics) * 100,
            'slowest_operations': sorted(self.performance_metrics, key=lambda x: x['duration'], reverse=True)[:5],
            'operation_frequency': operations.most_common(10)
        }
    
    def analyze_errors(self):
        """Analyze error patterns"""
        if not self.errors:
            return {'total_errors': 0}
            
        error_types = Counter()
        for error in self.errors:
            content = error['content'].lower()
            if 'crash' in content:
                error_types['crashes'] += 1
            elif 'exception' in content:
                error_types['exceptions'] += 1
            elif 'error' in content:
                error_types['errors'] += 1
            elif 'fatal' in content:
                error_types['fatal_errors'] += 1
        
        return {
            'total_errors': len(self.errors),
            'error_types': dict(error_types),
            'error_details': self.errors[:10]  # First 10 errors for review
        }
    
    def generate_report(self):
        """Generate comprehensive analysis report"""
        user_analysis = self.analyze_user_behavior()
        performance_analysis = self.analyze_performance()
        error_analysis = self.analyze_errors()
        
        report = {
            'log_file': str(self.log_file),
            'total_log_lines': len(self.logs),
            'analysis_timestamp': datetime.now().isoformat(),
            'user_behavior': user_analysis,
            'performance': performance_analysis,
            'errors': error_analysis,
            'summary': {
                'total_user_actions': len(self.user_actions),
                'total_performance_metrics': len(self.performance_metrics),
                'total_network_requests': len(self.network_requests),
                'total_audio_events': len(self.audio_events),
                'total_ui_events': len(self.ui_events),
                'total_errors': len(self.errors)
            }
        }
        
        return report
    
    def print_report(self, report):
        """Print formatted analysis report"""
        print("🧪 ELYTHRA MUSIC - LOG ANALYSIS REPORT")
        print("=" * 50)
        print(f"📁 Log File: {report['log_file']}")
        print(f"📊 Total Log Lines: {report['total_log_lines']}")
        print(f"⏰ Analysis Time: {report['analysis_timestamp']}")
        print()
        
        # User Behavior Analysis
        user_behavior = report['user_behavior']
        if user_behavior:
            print("👤 USER BEHAVIOR ANALYSIS")
            print("-" * 30)
            print(f"Total Actions: {user_behavior['total_actions']}")
            if user_behavior['session_duration_seconds']:
                print(f"Session Duration: {user_behavior['session_duration_seconds']:.1f} seconds")
                print(f"Actions per Minute: {user_behavior['actions_per_minute']:.1f}")
            print(f"Unique Screens Visited: {user_behavior['unique_screens']}")
            
            print("\n📱 Most Used Screens:")
            for screen, count in user_behavior['most_used_screens']:
                print(f"  • {screen}: {count} actions")
            
            print("\n🎯 Most Common Actions:")
            for action, count in user_behavior['most_common_actions']:
                print(f"  • {action}: {count} times")
            print()
        
        # Performance Analysis
        performance = report['performance']
        if performance:
            print("⚡ PERFORMANCE ANALYSIS")
            print("-" * 30)
            print(f"Total Operations: {performance['total_operations']}")
            print(f"Average Duration: {performance['average_duration_ms']:.1f}ms")
            print(f"Success Rate: {performance['success_rate']:.1f}%")
            print(f"Failed Operations: {performance['failed_operations']}")
            
            print("\n🐌 Slowest Operations:")
            for op in performance['slowest_operations']:
                print(f"  • {op['operation']}: {op['duration']}ms [{op['status']}]")
            print()
        
        # Error Analysis
        errors = report['errors']
        if errors['total_errors'] > 0:
            print("🚨 ERROR ANALYSIS")
            print("-" * 30)
            print(f"Total Errors: {errors['total_errors']}")
            
            if 'error_types' in errors:
                print("\nError Types:")
                for error_type, count in errors['error_types'].items():
                    print(f"  • {error_type}: {count}")
            
            print("\n📋 Recent Errors:")
            for error in errors['error_details'][:5]:
                print(f"  Line {error['line_num']}: {error['content'][:100]}...")
            print()
        else:
            print("✅ NO ERRORS DETECTED")
            print()
        
        # Summary
        summary = report['summary']
        print("📈 SUMMARY")
        print("-" * 30)
        print(f"User Actions: {summary['total_user_actions']}")
        print(f"Performance Metrics: {summary['total_performance_metrics']}")
        print(f"Network Requests: {summary['total_network_requests']}")
        print(f"Audio Events: {summary['total_audio_events']}")
        print(f"UI Events: {summary['total_ui_events']}")
        print(f"Errors: {summary['total_errors']}")

def main():
    if len(sys.argv) != 2:
        print("Usage: python analyze_logs.py <log_file>")
        print("Example: python analyze_logs.py testing_logs/session_2025-06-07_14-30-15.log")
        sys.exit(1)
    
    log_file = sys.argv[1]
    analyzer = LogAnalyzer(log_file)
    
    print("🔍 Parsing log file...")
    if not analyzer.parse_logs():
        sys.exit(1)
    
    print("📊 Analyzing data...")
    report = analyzer.generate_report()
    
    # Save detailed report as JSON
    report_file = Path(log_file).with_suffix('.json')
    with open(report_file, 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"💾 Detailed report saved to: {report_file}")
    print()
    
    # Print summary report
    analyzer.print_report(report)

if __name__ == "__main__":
    main()