#import <substrate.h>

#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH 31
#endif

#if !defined(sys_ptrace_request)
#define sys_ptrace_request 26
#endif

static int (*_ptraceHook)(int request, pid_t pid, caddr_t addr, int data);
static int (*_syscall)(long request, long pid, long addr, long data);

static int $ptraceHook(int request, pid_t pid, caddr_t addr, int data) {
	if (request == PT_DENY_ATTACH) {
		request = -1;
	}
	return _ptraceHook(request,pid,addr,data);
}

static int $syscall(long request, long pid, long addr, long data) {
	if (request == sys_ptrace_request) {
		return 0;
	}
	return _syscall(request,pid,addr,data);
}

%ctor {
	MSHookFunction((void *)MSFindSymbol(NULL,"_ptrace"), (void *)$ptraceHook, (void **)&_ptraceHook);
	MSHookFunction((void *)MSFindSymbol(NULL,"_syscall"),(void *)$syscall,(void **)&_syscall);
}
