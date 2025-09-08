<script lang="ts">
	import { Effect } from 'effect';

	let state: { result: string; count: number } = $state({
		result: 'Loading...',
		count: 0
	});

	// Simple Effect program that succeeds with a greeting
	const program = Effect.succeed('Hello from Effect!');

	// More complex Effect program that does some computation
	const countProgram = Effect.gen(function* () {
		// Simulate some async work
		yield* Effect.sleep('100 millis');
		return state.count + 1;
	});

	$effect(() => {
		Effect.runPromise(program).then((greeting) => {
			state.result = greeting;
		});
	});

	// Function to increment counter using Effect
	function increment() {
		Effect.runPromise(countProgram).then((newCount) => {
			state.count = newCount;
		});
	}
</script>

<div class="m-8 p-4 border border-gray-300 rounded-md shadow-sm">
	<h2 class="text-xl font-semibold mb-2">Effect Result:</h2>
	<p class="font-bold text-blue-600">{state.result}</p>

	<div class="mt-4">
		<h3 class="text-lg font-medium mb-2">Effect Counter: {state.count}</h3>
		<button
			onclick={increment}
			class="bg-blue-600 hover:bg-blue-800 text-white py-2 px-4 rounded-md transition-colors duration-200 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-opacity-50"
		>
			Increment with Effect
		</button>
	</div>
</div>
