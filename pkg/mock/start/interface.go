// Code generated by mockery v1.0.0. DO NOT EDIT.

package sdk

import (
	context "context"
	io "io"

	mock "github.com/stretchr/testify/mock"

	start "github.com/convox/convox/pkg/start"
)

// Interface is an autogenerated mock type for the Interface type
type Interface struct {
	mock.Mock
}

// Start2 provides a mock function with given fields: _a0, _a1, _a2
func (_m *Interface) Start2(_a0 context.Context, _a1 io.Writer, _a2 start.Options2) error {
	ret := _m.Called(_a0, _a1, _a2)

	var r0 error
	if rf, ok := ret.Get(0).(func(context.Context, io.Writer, start.Options2) error); ok {
		r0 = rf(_a0, _a1, _a2)
	} else {
		r0 = ret.Error(0)
	}

	return r0
}
